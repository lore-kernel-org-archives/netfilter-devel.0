From: NaNu <emmanuel.guiton@neuf.fr>
Subject: The CRD System (part 1)
Date: Thu, 20 Jan 2005 11:03:12 +0100
Message-ID: <41EF81E0.7020905@neuf.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040508010806060506060002"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040508010806060506060002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi all!

Last year, I wrote a paper about a new system to help defending a 
network against TCP SYN flooding attacks. I presented the idea at the 
NordSec conference and you can find the paper itself in the joint files 
(e-mail part 2).

For the purpose of this paper, I had implemented a prototype of what I 
called a Connection Request distribution system (for more details, see 
the actual paper) using netfilter. Now, if you find it interesting, you 
could develop it to a fully usable version (particularly changing the 
allocation of memory from static to dynamic). I can't work on that 
project anymore but you can contact me for any help.

Please, note that I wrote the program with a 2.4.23 kernel with the 
nfnetlink and Nfnetlink-ctnetlink patches from patch-o-matic.
For any question, please contact me.

       Emmanuel

--------------040508010806060506060002
Content-Type: text/plain;
 name="patch_CRD_iptables"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch_CRD_iptables"

diff -Nru iptables-1.2.11/extensions/libipt_SYNDIS.c iptables-1.2.11-modified/extensions/libipt_SYNDIS.c
--- iptables-1.2.11/extensions/libipt_SYNDIS.c	1970-01-01 01:00:00.000000000 +0100
+++ iptables-1.2.11-modified/extensions/libipt_SYNDIS.c	2004-04-27 09:51:07.000000000 +0200
@@ -0,0 +1,486 @@
+/* Shared library add-on to iptables to add SYN-ditributor functionnality support. */
+
+/* So far, this code is only a test implementation to validate the idea in:
+ * "Distributed Defense Against Low-Bandwidth TCP SYN Flooding Attacks", Emmanuel
+ * Guiton (that's me), to be published (I wish).
+ */
+
+/* FIX ME & TO DO:
+ *   - command could be more user friendly. Particularly regarding the compulsory
+ *     specification of the lists of hosts on which the SYN requests are distributed.
+ *   - exhaustive testing.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <string.h>
+#include <arpa/inet.h>
+#include <netinet/in.h>
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_SYNDIS.h>
+
+
+/* Function which prints out usage message. */
+
+static void
+help(void)
+{
+	printf(
+"SYNDIS v%s options:\n"
+" --sd-relays <ipaddr:p{port}>[:b{backlog size}][:t{timeout length}]\n"
+"			  [<,ipaddr:p{port}>[:b{backlog size}][:t{timeout length}]...]\n"
+"           Required list of available hosts on which three-way handshakes\n"
+"			can be performed.\n"
+" --sd-params [b{backlog size}][:][t{timeout length}]\n"
+"           Specify parameters of the host to be defended. You can \n"
+"			precise the backlog queue size (unit is number of half-open\n"
+"			connections, default is 2048) and the TCP timeout length in\n"
+"           seconds (default is 9).\n"
+"			See /proc/sys/net/ipv4/tcp_max_syn_backlog and\n"
+"			/proc/sys/net/ipv4/tcp_synack_retries to set these parameters\n"
+"			on the host.\n"
+" --sd-gua <ipaddr>\n"
+"			Globally unique address of the target. I.e. address of the\n"
+"			target, as seen from the external network.\n\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "sd-params", 1, 0, '1' },
+	{ "sd-relays", 1, 0, '2' },
+	{ "sd-gua", 1, 0, '3' },
+	{ 0 }
+};
+
+
+/* Initialize the target. */
+static void
+init(struct ipt_entry_target *target, unsigned int *nfcache)
+{
+	struct ipt_sd_data	*sd_data = (struct ipt_sd_data *) target->data; 
+	int					 i;
+	struct in_addr		 temp_addr;
+	
+	/* the use of nfcahe is still very unclear for me,
+	 * but this seems to be a safe option. */
+	*nfcache |= NFC_UNKNOWN;
+	
+	sd_data->target_backlog_size=SD_DEFAULT_BACKLOG_SIZE;
+	sd_data->target_tcp_timeout=SD_DEFAULT_TCP_TIMEOUT;
+	inet_aton("0.0.0.0",&temp_addr);
+	sd_data->gua_target=temp_addr.s_addr;
+	for (i=0;i<15;i++)
+	{
+		inet_aton("0.0.0.0",&temp_addr);
+		sd_data->host_list[i].address=temp_addr.s_addr;
+		sd_data->host_list[i].port=0;
+		sd_data->host_list[i].backlog_size=SD_DEFAULT_BACKLOG_SIZE;
+		sd_data->host_list[i].tcp_timeout=SD_DEFAULT_TCP_TIMEOUT;
+	}
+}
+
+
+/* Fix me: displaying all the information is not necessary
+ * useful and may fill the screen...*/
+
+/* Prints out the targinfo. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_target *target,
+      int numeric)
+{
+	struct ipt_sd_data	*sd_data = (struct ipt_sd_data *) target->data; 
+	unsigned int		 i;
+	struct in_addr		 temp_addr;
+
+	printf("| target parameters: backlog size %ld  tcp timeout %lds  ",
+			sd_data->target_backlog_size, sd_data->target_tcp_timeout);
+
+	i=0;
+	temp_addr.s_addr = sd_data->host_list[i].address;
+	while(strcmp(inet_ntoa(temp_addr),"0.0.0.0")!=0 && i<15)
+	{
+		printf("| relay %d: %s  port %d  backlog size %ld  tcp timeout %lds  ", i+1,
+				inet_ntoa(temp_addr), sd_data->host_list[i].port,
+				sd_data->host_list[i].backlog_size, sd_data->host_list[i].tcp_timeout);
+		i++;
+		temp_addr.s_addr = sd_data->host_list[i].address;
+	}
+	
+	temp_addr.s_addr = sd_data->gua_target;
+	if (strcmp("0.0.0.0", inet_ntoa(temp_addr)))
+		printf("| GUA address: %s  ", inet_ntoa(temp_addr));
+}
+
+
+/* Function which parses :p argument */
+static int
+parse_p(char *arg_str, struct ipt_sd_data *sd_data, int host_index)
+{
+	char	*separator;
+	
+	arg_str++;
+	if (*arg_str=='\0')
+		exit_error(PARAMETER_PROBLEM, "Value required after parameter :p in --sd-relays");
+
+	separator=strchr(arg_str, '-');
+	if(separator)
+	{
+		exit_error(PARAMETER_PROBLEM, "Only one port can be specified after option :p in --sd-relays");
+	}
+	else
+	{
+		sd_data->host_list[host_index].port = strtol(arg_str, NULL, 0);
+		if ( sd_data->host_list[host_index].port < 1 || sd_data->host_list[host_index].port > 65535 )
+			exit_error(PARAMETER_PROBLEM, "Invalid port number after option :p in --sd-relays");
+	}
+	return 1;
+}
+
+
+/* Function which parses :b and :t arguments.
+ * Caution: this function works differently than the previous one.
+ * the char *arg_str includes the argument initial in order to reuse
+ * the function with both b and t parameters.
+ */
+
+/* Fix me: does not impose any upper bound on backlog size of
+ * TCP timeout values. Ok in theory, in practice it cannot be
+ * any value.
+ */
+
+static int
+parse_bt(char *arg_str, long int *param, int host_index)
+{
+	char	argument, *name;
+	
+	name=malloc(sizeof(char)*7);
+	if (host_index > -1)
+		strcpy(name,"relays");
+	else
+		strcpy(name,"params");
+	
+	argument=*arg_str;
+
+	arg_str++;
+	if (*arg_str=='\0')
+		exit_error(PARAMETER_PROBLEM, "Value required after parameter :%c in --sd-%s", argument, name);
+
+	if((*param=strtol(arg_str, NULL, 0))<1)
+		exit_error(PARAMETER_PROBLEM, "Invalid value after parameter :%c in --sd-%s", argument, name);
+	
+	return 1;
+}
+
+
+/* Function which parses relay data */
+static int      
+parse_relay(char *arguments, struct ipt_sd_data *sd_data, int host_index)
+{
+	char			*separator, *next_separator;
+	int				 p=0, b=0, t=0;
+	struct in_addr	 temp_addr;
+
+	separator=strchr(arguments, ':');
+	if (separator)
+	{
+		*separator='\0';
+		if (!inet_aton(arguments, &(temp_addr)))
+			exit_error(PARAMETER_PROBLEM, "Invalid address after --sd-relays");
+		else
+			sd_data->host_list[host_index].address = temp_addr.s_addr;
+		separator++;
+		if (*separator=='\0')
+			exit_error(PARAMETER_PROBLEM, "Port number required in option --sd-relays");
+		while (*separator != '\0')
+		{
+			switch (*separator)
+			{
+				case 'p':
+					if (p==1)
+						exit_error(PARAMETER_PROBLEM, "Parameter :p specified twice in --sd-relays");
+					
+					next_separator=strchr(separator, ':');
+					if (next_separator)
+					{
+						*next_separator='\0';
+						p=parse_p(separator, sd_data, host_index);
+						separator=next_separator+1;
+					}
+					else
+					{
+						p=parse_p(separator, sd_data, host_index);
+						*separator='\0';	/* last argument, end of checking*/
+					}
+					break;
+				
+				case 'b':
+					if (b==1)
+						exit_error(PARAMETER_PROBLEM, "Parameter :b specified twice in --sd-relays");
+					
+					next_separator=strchr(separator, ':');
+					if (next_separator)
+					{
+						*next_separator='\0';
+						b=parse_bt(separator, &(sd_data->host_list[host_index].backlog_size), host_index);
+						separator=next_separator+1;
+					}
+					else
+					{
+						b=parse_bt(separator, &(sd_data->host_list[host_index].backlog_size), host_index);
+						*separator='\0';	/* last argument, end of checking*/
+					}
+					break;
+				
+				case 't':
+					if (t==1)
+						exit_error(PARAMETER_PROBLEM, "Parameter :b specified twice in --sd-relays");
+					
+					next_separator=strchr(separator, ':');
+					if (next_separator)
+					{
+						*next_separator='\0';
+						t=parse_bt(separator, &(sd_data->host_list[host_index].tcp_timeout), host_index);
+						separator=next_separator+1;
+					}
+					else
+					{
+						t=parse_bt(separator, &(sd_data->host_list[host_index].tcp_timeout), host_index);
+						*separator='\0';	/* last argument, end of checking*/
+					}
+					break;
+				
+				default: /* unknown parameter after ":" */
+					exit_error(PARAMETER_PROBLEM, "Invalid option after \":\" in --sd-relays");
+					break;
+			}
+		}
+	}
+	else /* no colon found means only ip address provided */
+	{
+		exit_error(PARAMETER_PROBLEM, "Missing at least one parameter after --sd-relays");
+	}
+	
+	if (!p)
+		exit_error(PARAMETER_PROBLEM, "Port number required in option --sd-relays");
+	
+	return 1;
+}
+
+
+/* Function which parses command options */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      struct ipt_entry_target **target)
+{
+	struct ipt_sd_data	*sd_data = (struct ipt_sd_data *) (*target)->data; 
+	char				*separator, *data;
+	int					 host_index=0;
+	int					 params_b=0, params_t=0;
+	struct in_addr		 temp_addr;
+
+	
+	if (entry->ip.proto != IPPROTO_TCP)
+	{
+		exit_error(PARAMETER_PROBLEM, "TCP protocol is required");
+		return 0;
+	}
+	
+	/* Fix me: this check is not enough. User could enter a network address, for example.
+	 * The user MUST NOT enter any address other than the address of the host to be defended.
+	 */
+	if (!(entry->nfcache & NFC_IP_DST))
+	{
+		exit_error(PARAMETER_PROBLEM, "Single host destination (=host to be defended) is required");
+		return 0;
+	}
+		
+	switch (c)
+	{
+		case '1': /* --sd-params */
+			if (check_inverse(optarg, &invert, NULL, 0))
+				exit_error(PARAMETER_PROBLEM, "Unexpected `!' after --sd-params");
+
+			data=optarg;
+			if (*data=='\0')
+				exit_error(PARAMETER_PROBLEM, "Parameter b or t expected after --sd-params");
+
+			while (*data!='\0')
+			{
+				switch (*data)
+				{
+					case 'b':
+						if (params_b==1)
+							exit_error(PARAMETER_PROBLEM, "Parameter :b specified twice in --sd-params");
+						
+						separator=strchr(data, ':');
+						if (separator)
+						{
+							*separator='\0';
+						params_b=parse_bt(data, &(sd_data->target_backlog_size), -1);
+							data=separator+1;
+						}
+						else
+						{
+						params_b=parse_bt(data, &(sd_data->target_backlog_size), -1);
+							*data='\0';	/* last argument, end of checking*/
+						}
+						break;
+					
+					case 't':
+						if (params_t==1)
+							exit_error(PARAMETER_PROBLEM, "Parameter :t specified twice in --sd-params");
+
+						separator=strchr(data, ':');
+						if (separator)
+						{
+							*separator='\0';
+							params_t=parse_bt(data, &(sd_data->target_tcp_timeout), -1);
+							data=separator+1;
+						}
+						else
+						{
+							params_t=parse_bt(data, &(sd_data->target_tcp_timeout), -1);
+							*data='\0';	/* last argument, end of checking*/
+						}
+						break;
+						
+					default: /* unknown parameter after ":" */
+						exit_error(PARAMETER_PROBLEM, "Invalid parameter identifier after \":\" in --sd-params");
+						break;
+				}
+			}
+			break;
+
+		case '2': /* --sd-relays */
+			if (check_inverse(optarg, &invert, NULL, 0))
+				exit_error(PARAMETER_PROBLEM, "Unexpected `!' after --sd-relays");
+			
+			data=optarg;
+			if (*data=='\0') /* Should not happen */
+				exit_error(PARAMETER_PROBLEM, "Empty parameters in --sd-relays");
+			while (*data!='\0')
+			{
+				separator=strchr(data, ',');
+				if (separator)
+				{
+					*separator='\0';
+					parse_relay(data, sd_data, host_index);
+					data=separator+1;
+					host_index++;
+				}
+				else /* last relay: set data to '\0' */
+				{
+					parse_relay(data, sd_data, host_index);
+					*data='\0';
+				}
+			}
+			*flags+=1;
+			break;
+
+		case '3': /* --sd-gua */
+			if (check_inverse(optarg, &invert, NULL, 0))
+				exit_error(PARAMETER_PROBLEM, "Unexpected `!' after --sd-gua");
+			
+			if (!inet_aton(optarg, &(temp_addr)))
+				exit_error(PARAMETER_PROBLEM, "Invalid address after --sd-gua");
+			else
+				sd_data->gua_target=temp_addr.s_addr;
+			
+			break;
+
+		default:
+			return 0;
+	}
+
+	return 1; /* Check went fine.*/
+}
+
+/* Fix me:
+ * Purging data if --sd-relays is not specified?
+ * Or modifying --sd-relays in --sd-add-relay (more user friendly)
+ */
+/* Final check; */
+static void final_check(unsigned int flags)
+{
+	if (!flags) 
+		exit_error(PARAMETER_PROBLEM, "Option --sd-relays required in target SYNDIS");
+	else
+	{
+		if (flags!=1) /* Should not happen. */
+			exit_error(PARAMETER_PROBLEM, "Undefined parameter error in target SYNDIS");
+	}
+}
+
+
+/* Saves the union ipt_targinfo in parsable form to stdout. */
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+{
+	struct ipt_sd_data	*sd_data = (struct ipt_sd_data *) target->data; 
+	int					 i=0;
+	struct in_addr		 temp_addr;
+	
+	printf("--sd-relays");
+	while(sd_data->host_list[i].port!=0 && i<15)
+	{
+		temp_addr.s_addr = sd_data->host_list[i].address;
+		printf(" %s:p%d", inet_ntoa(temp_addr), sd_data->host_list[i].port);
+		
+		if (sd_data->host_list[i].backlog_size!=SD_DEFAULT_BACKLOG_SIZE
+			&& sd_data->host_list[i].tcp_timeout!=SD_DEFAULT_TCP_TIMEOUT)
+		{
+			printf(":b%ld:t%ld", sd_data->host_list[0].backlog_size, sd_data->host_list[0].tcp_timeout);
+		}
+		else
+		{
+			if (sd_data->host_list[i].backlog_size!=SD_DEFAULT_BACKLOG_SIZE)
+				printf(":b%ld", sd_data->host_list[i].backlog_size);
+			if (sd_data->host_list[i].tcp_timeout!=SD_DEFAULT_TCP_TIMEOUT)
+				printf(":t%ld", sd_data->host_list[i].tcp_timeout);
+		}
+		i++;
+	}
+	
+	if (sd_data->host_list[0].backlog_size!=SD_DEFAULT_BACKLOG_SIZE
+		&& sd_data->host_list[0].tcp_timeout!=SD_DEFAULT_TCP_TIMEOUT)
+	{
+		printf(" --sd-params :b%ld:t%ld ", sd_data->host_list[0].backlog_size,
+			sd_data->host_list[0].tcp_timeout);
+	}
+	else
+	{
+		if (sd_data->host_list[0].backlog_size!=SD_DEFAULT_BACKLOG_SIZE)
+			printf(" --sd-params :b%ld", sd_data->host_list[0].backlog_size);
+		if (sd_data->host_list[0].tcp_timeout!=SD_DEFAULT_TCP_TIMEOUT)
+			printf(" --sd-params :t%ld", sd_data->host_list[0].tcp_timeout);
+	}
+	
+	temp_addr.s_addr = sd_data->gua_target;
+	if (!strcmp(inet_ntoa(temp_addr),"0.0.0.0"))
+		printf(" --sd-gua %s", inet_ntoa(temp_addr));
+}
+
+static
+struct iptables_target syn_distributor
+= { NULL,
+    "SYNDIS",
+    IPTABLES_VERSION,
+    IPT_ALIGN(sizeof(struct ipt_sd_data)),
+    IPT_ALIGN(sizeof(struct ipt_sd_data)),
+    &help,
+    &init,
+    &parse,
+    &final_check,
+    &print,
+    &save,
+    opts
+};
+
+void _init(void)
+{
+	register_target(&syn_distributor);
+}

--------------040508010806060506060002
Content-Type: text/plain;
 name="patch_CRD_kernel"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch_CRD_kernel"

diff -Nru linux-2.4.28/include/linux/netfilter_ipv4/ip_conntrack_core.h linux-2.4.28-modified/include/linux/netfilter_ipv4/ip_conntrack_core.h
--- linux-2.4.28/include/linux/netfilter_ipv4/ip_conntrack_core.h	2004-12-02 20:59:03.000000000 +0100
+++ linux-2.4.28-modified/include/linux/netfilter_ipv4/ip_conntrack_core.h	2004-12-05 22:45:59.000000000 +0100
@@ -50,9 +50,15 @@
 	return NF_ACCEPT;
 }
 
+
+/* SYNDIS specific. Change conntrack information. */
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+int ip_ct_sd_change_conntrack_info(struct ip_conntrack *conntrack, u_int32_t new_ip, u_int16_t new_tcpport);
+#endif
+
+
 extern struct list_head *ip_conntrack_hash;
 extern struct list_head ip_conntrack_ordered_list;
 extern struct list_head ip_conntrack_expect_list;
 DECLARE_RWLOCK_EXTERN(ip_conntrack_lock);
 #endif /* _IP_CONNTRACK_CORE_H */
-
diff -Nru linux-2.4.28/include/linux/netfilter_ipv4/ip_conntrack.h linux-2.4.28-modified/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.4.28/include/linux/netfilter_ipv4/ip_conntrack.h	2004-12-02 20:59:03.000000000 +0100
+++ linux-2.4.28-modified/include/linux/netfilter_ipv4/ip_conntrack.h	2004-12-05 22:45:59.000000000 +0100
@@ -223,6 +223,14 @@
 	} nat;
 #endif /* CONFIG_IP_NF_NAT_NEEDED */
 
+/* SYNDIS counter, SYNDIS specific. Important: must be initialized to NULL
+ * (done in ip_conntrack_core.c (ip_conntrack_alloc())).
+ */
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+	/* Used to identify the conntrack counter which depends on this conntrack */
+	unsigned int *ipt_sd_syndis_counter;
+#endif
+
 };
 
 /* get master conntrack via master expectation */
@@ -322,6 +330,12 @@
 	IPCT_PROTOINFO,
 	IPCT_HELPINFO,
 	IPCT_NATINFO,
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+	/* Added for ipt_SYNDIS module's purpose. */
+	IPCT_SD_TCP_ASSURED,
+	IPCT_SD_LAST_FINACK,
+	IPCT_SD_LAST_3WH_ACK
+#endif
 };
 
 #ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
@@ -375,5 +389,9 @@
 static inline void ip_conntrack_do_cached_events(struct ip_conntrack *ct) {}
 #endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
 
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+extern void ip_ct_proto_tcp_set_timeout_syn_received(unsigned long new_value);
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* _IP_CONNTRACK_H */
diff -Nru linux-2.4.28/include/linux/netfilter_ipv4/ip_conntrack_tcp.h linux-2.4.28-modified/include/linux/netfilter_ipv4/ip_conntrack_tcp.h
--- linux-2.4.28/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2002-11-29 00:53:15.000000000 +0100
+++ linux-2.4.28-modified/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2004-12-05 22:45:59.000000000 +0100
@@ -23,6 +23,36 @@
 	/* Poor man's window tracking: sequence number of valid ACK
            handshake completion packet */
 	u_int32_t handshake_ack;
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+	u_int32_t handshake_seq; /* the sequence number of valid _INITIAL_ SYN */
+	u_int32_t new_handshake_ack; /* value of handshake_ack from the target. */
+	/* Various flags: */
+	u_int16_t freeze_state: 1, /* stops the analysis of the conntrack state. Used while
+							    * moving the conntrack from a relay to the target. */
+			  syndis_on:    1, /* On that connection, the SYN packet was directed to a relay */
+			  last_doff:    4, /* tcp header length, including options. */
+			  rcvr_doff:    4, /* receiver doff, used to retrieve e.g. receiver timestamp */
+			  ip_df:        1, /* IP don't fragment. See the remark about ip field hereafter. */
+			  unused:		5; /* Some free space to implement more things. */
+	
+	u_int32_t original_opts[10]; /* TCP options in the original direction from ACK packet */
+	u_int32_t reply_opts[10]; /* regularly updated TCP options in the reply direction */
+	/* Logic would not place these here as they are not tcp fields. */
+	struct timeval original_ack_time; /* used to update sender timestamp in SYNDIS messages. */
+	u_int32_t original_ack_timestamp; /* Idem. Value of client timestamp in ACK message */
+	u_int32_t reply_ack_timestamp;    /* Value of relay timestamp in ACK message (from client). */
+		
+	/* Record first SYN packet if conntrack->proto.tcp.syndis is on.
+	 * if the connection is legitimate, this packet has to be resent later. */
+	u_int8_t  *ipt_sd_original_syn_packet;
+	u_int16_t  ipt_sd_syn_packet_length;
+	
+	/* One data packet may have to be recorded and sent immediately after
+	 * the last message of the three-way handshake; it is recorded here
+	 * thanks to the ipt_sd_record_data_packet function. */
+	u_int8_t  *ipt_sd_first_data_packet;
+	u_int16_t  ipt_sd_packet_length;
+#endif
 };
 
 #endif /* _IP_CONNTRACK_TCP_H */
diff -Nru linux-2.4.28/include/linux/netfilter_ipv4/ip_conntrack_tuple.h linux-2.4.28-modified/include/linux/netfilter_ipv4/ip_conntrack_tuple.h
--- linux-2.4.28/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2003-11-28 19:26:21.000000000 +0100
+++ linux-2.4.28-modified/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2004-12-05 22:45:59.000000000 +0100
@@ -18,6 +18,11 @@
 
 	struct {
 		u_int16_t port;
+/* SYNDIS specific */
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+		u_int32_t seq_offset; /* (receiver) sequence number offset */
+		u_int32_t ts_offset;  /* (receiver) timestamp offset */
+#endif		
 	} tcp;
 	struct {
 		u_int16_t port;
diff -Nru linux-2.4.28/include/linux/netfilter_ipv4/ipt_SYNDIS.h linux-2.4.28-modified/include/linux/netfilter_ipv4/ipt_SYNDIS.h
--- linux-2.4.28/include/linux/netfilter_ipv4/ipt_SYNDIS.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.4.28-modified/include/linux/netfilter_ipv4/ipt_SYNDIS.h	2004-05-19 13:30:04.000000000 +0200
@@ -0,0 +1,59 @@
+#ifndef _IPT_SYNDIS_H
+#define _IPT_SYNDIS_H
+
+#define SD_DEFAULT_TCP_TIMEOUT	9
+#define SD_DEFAULT_BACKLOG_SIZE	2048
+
+extern void ipt_sd_record_data_packet(struct iphdr* iph);
+
+struct ipt_sd_host
+{
+	u_int32_t	address;		/* address of the host */
+	int			port; 			/* three-way handshake port */
+	long int	backlog_size;	/* size of the backlog queue
+									 * = max number of half-open connections */
+	long int	tcp_timeout;	/* length of the tcp timeout in seconds */
+};
+
+struct ipt_sd_data
+{
+	/* Fix me:
+	 * gua_target is not used in ipt_SYNDIS.c
+	 * It can be deduced from ipt_entry and it's stored in ipt_sd_addr_target
+	 */
+	u_int32_t			gua_target; /* Globally unique IP address of the target. (=Address
+									 * as seen from the external network. = IP address to
+									 * which the TCP connections are translated.) */
+	/* Fix me: host_list[15] is a temporary solution. Ideal is to use a linked list, but then
+	 * you cannot align it correctly in iptables_target structure since you do not know in
+	 * advance the size of the linkde list. To quote a mail by Henrik Nordstrom:
+	 *		
+	 * "Not sure doing this is even possible. The target/match size needs to be 
+	 *	static in iptables extensions.
+	 *	
+	 *	What surely is possible is to have the list loaded into another module via 
+	 *	/proc or something, and then look up the list in the check() function of 
+	 *	the target/match.
+	 *	
+	 *	Extending iptables to support variable sized targets/matches is possible 
+	 *	but simply dropping the size checks from ip_tables.c and extending the 
+	 *	userspace to allow matches/extensions to grow their data, but you will 
+	 *	need to encode the data using offsets not pointers."
+	 */
+	struct ipt_sd_host	host_list[15]; /* List of available relay hosts to perform the
+										* three-way handshakes. Addresses should be local
+										* addresses. */
+	long int			target_tcp_timeout;  /* TCP timeout length on the defended host */
+	long int			target_backlog_size; /* Backlog size of the defended host */
+	/* Fix me:
+	 * min_napt_port and max_napt_port are not used in ipt_SYNDIS.c
+	 */
+	int					min_napt_port; /* Range of available port numbers that can be used to */
+	int					max_napt_port; /* perform NAPT. Default is 1024-17408 (=8 computers 
+										* with backlog queue size of 2048 half-open connections)
+										* Should support 1Mb/s attack if configured with only 1
+										* TCP retransmission (9s in Linux). Goal of this
+										* implementation: to determine if it's true or not :) */
+};
+
+#endif /*_IPT_SYNDIS_H*/
diff -Nru linux-2.4.28/net/ipv4/netfilter/ip_conntrack_core.c linux-2.4.28-modified/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.4.28/net/ipv4/netfilter/ip_conntrack_core.c	2004-12-02 20:59:03.000000000 +0100
+++ linux-2.4.28-modified/net/ipv4/netfilter/ip_conntrack_core.c	2004-12-02 21:07:06.000000000 +0100
@@ -548,6 +548,55 @@
 	return NF_DROP;
 }
 
+
+/* For SYNDIS module purpose.
+ * Change the tuplehash information in the reply direction.
+ */
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+int ip_ct_sd_change_conntrack_info(struct ip_conntrack *conntrack, u_int32_t new_ip, u_int16_t new_tcpport)
+{
+	
+	unsigned int					 hash_original, hash_reply;
+	struct ip_conntrack_tuple_hash  *tuple_hash;
+	
+	WRITE_LOCK(&ip_conntrack_lock);
+	/* First delete the old conntrack from the hash list.
+	 * (like in clean_from_lists()) */
+	hash_original = hash_conntrack(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	hash_reply    = hash_conntrack(&conntrack->tuplehash[IP_CT_DIR_REPLY].tuple);
+	LIST_DELETE(&ip_conntrack_hash[hash_original], &conntrack->tuplehash[IP_CT_DIR_ORIGINAL]);
+	LIST_DELETE(&ip_conntrack_hash[hash_reply], &conntrack->tuplehash[IP_CT_DIR_REPLY]);
+	LIST_DELETE(&ip_conntrack_ordered_list, &conntrack->olist);
+	
+	/* Then change conntrack information */
+	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip         = new_ip;
+	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.tcp.port = new_tcpport;
+	
+	/* Then insert the new conntrack info in the hash list
+	 * (like in __ip_conntrack_confirm()) */
+	hash_original = hash_conntrack(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	hash_reply    = hash_conntrack(&conntrack->tuplehash[IP_CT_DIR_REPLY].tuple);
+
+	if (!LIST_FIND(&ip_conntrack_hash[hash_original], conntrack_tuple_cmp,
+				   struct ip_conntrack_tuple_hash *, &conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple, NULL)
+	    && !LIST_FIND(&ip_conntrack_hash[hash_reply], conntrack_tuple_cmp,
+				      struct ip_conntrack_tuple_hash *, &conntrack->tuplehash[IP_CT_DIR_REPLY].tuple, NULL))
+	{
+		/* like in ip_conntrack_place_in_lists */
+		list_add_tail(&conntrack->olist, &ip_conntrack_ordered_list);
+		tuple_hash = &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
+		list_prepend(&ip_conntrack_hash[hash_conntrack(&tuple_hash->tuple)], tuple_hash);
+		tuple_hash = &conntrack->tuplehash[IP_CT_DIR_REPLY];
+		list_prepend(&ip_conntrack_hash[hash_conntrack(&tuple_hash->tuple)], tuple_hash);
+	}
+	WRITE_UNLOCK(&ip_conntrack_lock);
+	
+	/* if everything is ok. */
+	return 0;
+}
+#endif
+
+
 /* Returns true if a connection correspondings to the tuple (required
    for NAT). */
 int
@@ -746,6 +795,11 @@
 	ct->timeout.data = (unsigned long)ct;
 	ct->timeout.function = death_by_timeout;
 
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+	/* Initialization of syndis counter */
+	ct->ipt_sd_syndis_counter = NULL;
+#endif
+
 	INIT_LIST_HEAD(&ct->sibling_list);
 	atomic_inc(&ip_conntrack_count);
 	return ct;
diff -Nru linux-2.4.28/net/ipv4/netfilter/ip_conntrack_proto_tcp.c linux-2.4.28-modified/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- linux-2.4.28/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-12-02 20:59:03.000000000 +0100
+++ linux-2.4.28-modified/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-12-02 21:16:37.000000000 +0100
@@ -104,6 +104,16 @@
 	}
 };
 
+
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+/* For ipt_SYNDIS module. */
+void ip_ct_proto_tcp_set_timeout_syn_received(unsigned long new_value)
+{
+	ip_ct_tcp_timeout_syn_recv = new_value SECS;
+}
+#endif
+
+
 static int tcp_pkt_to_tuple(const void *datah, size_t datalen,
 			    struct ip_conntrack_tuple *tuple)
 {
@@ -161,6 +171,9 @@
 {
 	enum tcp_conntrack newconntrack, oldtcpstate;
 	struct tcphdr *tcph = (struct tcphdr *)((u_int32_t *)iph + iph->ihl);
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+	u_int32_t *tcpopt = (u_int32_t *)iph + iph->ihl + 5 /*sizeof(struct tcphdr)/4*/;
+#endif
 
 	/* We're guaranteed to have the base header, but maybe not the
            options. */
@@ -169,6 +182,11 @@
 		return -1;
 	}
 
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+	if (!conntrack->proto.tcp.freeze_state)
+	{
+#endif
+
 	WRITE_LOCK(&tcp_lock);
 	oldtcpstate = conntrack->proto.tcp.state;
 	newconntrack
@@ -195,6 +213,18 @@
 	    && tcph->syn && tcph->ack) {
 		conntrack->proto.tcp.handshake_ack
 			= htonl(ntohl(tcph->seq) + 1);
+			
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+			if (conntrack->proto.tcp.syndis_on)
+			{
+				/* Record options for further analysis. E.g. if there are timestamps,
+				 * the values have to be correctly changed when replying.
+				 */
+				memcpy(conntrack->proto.tcp.reply_opts, tcpopt, 4*tcph->doff - 20 /*=sizeof(struct tcphdr)*/);
+				conntrack->proto.tcp.rcvr_doff = tcph->doff;
+			}
+#endif			
+			
 		ip_conntrack_cache_event(IPCT_PROTOINFO);
 	}
 
@@ -214,12 +244,95 @@
 		    && tcph->ack_seq == conntrack->proto.tcp.handshake_ack) {
 			set_bit(IPS_ASSURED_BIT, &conntrack->status);
 			ip_conntrack_cache_event(IPCT_STATUS);
+
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+				if (conntrack->proto.tcp.syndis_on)
+				{
+					/* record data for sending messages from SYNDIS */
+					conntrack->proto.tcp.handshake_seq = htonl(ntohl(tcph->seq) - 1);
+					conntrack->proto.tcp.last_doff = tcph->doff;
+					if (iph->frag_off == htons(IP_DF))
+						conntrack->proto.tcp.ip_df = 1;
+					else
+						conntrack->proto.tcp.ip_df = 0;
+					if (tcph->doff > 5) /*options to reproduce*/
+						memcpy(conntrack->proto.tcp.original_opts, tcpopt, 4*tcph->doff - sizeof(struct tcphdr));
+					/* we want to keep the state of the conntrack as it is. It will
+					 * start again from that point when the connection will be moved. */	
+					conntrack->proto.tcp.freeze_state = 1;
+					/* Record the time so that if TCP options include timestamps, then the
+					 * firewall can update the sender timestamp (in the "fake" messages) by
+					 * adding the difference between "now" and the time recorded here.
+					 * NB: This is necessary only if timestamps are used, but I do not check for
+					 * them. It's easier to always record the time.
+					 */
+					do_gettimeofday(&conntrack->proto.tcp.original_ack_time);
+					/* Added event needed by ipt_SYNDIS module */
+					ip_conntrack_cache_event(IPCT_SD_TCP_ASSURED);
+				}
+#endif
+				
 		}
 
 		WRITE_UNLOCK(&tcp_lock);
 		ip_ct_refresh(conntrack, *tcp_timeouts[newconntrack]);
 	}
 
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+	} /* enf of "if (!conntrack->proto.tcp.freeze_state)" */
+	else
+	{
+
+	/* while connection is freezed, one TCP SYN packet is sent (triggered when the
+	 * state changes to ASSURED). Then we receive a SYN ACK packet that we have to
+	 * detect here and that will trigger the final ACK of the three way handshake
+	 * before to restore the connection state. */
+		
+		if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY && tcph->syn && tcph->ack)
+		{
+			WRITE_LOCK(&tcp_lock);
+			conntrack->proto.tcp.new_handshake_ack = htonl(ntohl(tcph->seq) + 1);
+			if (tcph->doff > 5)
+			{
+				memcpy(conntrack->proto.tcp.reply_opts, tcpopt, 4*tcph->doff - 20 /*=sizeof(struct tcphdr)*/);
+				conntrack->proto.tcp.rcvr_doff = tcph->doff;
+			}
+			WRITE_UNLOCK(&tcp_lock);
+			ip_conntrack_cache_event(IPCT_SD_LAST_3WH_ACK);
+		}
+		
+	/* If a packet is received in the original direction during the freezing (one
+	 * packet of data is following immediately the last message of the handshake),
+	 * take over it and sens it as soon as the connection is unfreezed. */	
+		if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
+		{
+			WRITE_LOCK(&tcp_lock);
+			conntrack->proto.tcp.ipt_sd_first_data_packet = kmalloc(len, GFP_ATOMIC);
+			memcpy(conntrack->proto.tcp.ipt_sd_first_data_packet, iph, len);
+			conntrack->proto.tcp.ipt_sd_packet_length = len;
+			WRITE_UNLOCK(&tcp_lock);
+			return NF_DROP;
+		}
+		
+		/* Block messages in REPLY direction. */
+		if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
+		{
+			/* Next is for using normal TCP end of connection instead of RST. */
+			/*if (tcph->fin && tcph->ack)
+			{
+				*//* when receiving fin ack, send last ack to finish closing the connection */
+			/*	ip_conntrack_cache_event(IPCT_SD_LAST_FINACK);
+			}*/
+			WRITE_LOCK(&tcp_lock);
+			memcpy(conntrack->proto.tcp.reply_opts, tcpopt, 4*tcph->doff - 20 /*=sizeof(struct tcphdr)*/);
+			conntrack->proto.tcp.rcvr_doff = tcph->doff;
+			WRITE_UNLOCK(&tcp_lock);
+			return NF_DROP;
+		}
+	}
+
+#endif
+	
 	return NF_ACCEPT;
 }
 
@@ -242,6 +355,15 @@
 	}
 
 	conntrack->proto.tcp.state = newconntrack;
+	
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+	/* initialization of variable that contains recorded packet info. */
+	conntrack->proto.tcp.ipt_sd_original_syn_packet = NULL;
+	conntrack->proto.tcp.ipt_sd_syn_packet_length   = 0;
+	conntrack->proto.tcp.ipt_sd_first_data_packet   = NULL;
+	conntrack->proto.tcp.ipt_sd_packet_length       = 0;
+#endif
+	
 	return 1;
 }
 
diff -Nru linux-2.4.28/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.4.28-modified/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.4.28/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-12-02 20:59:03.000000000 +0100
+++ linux-2.4.28-modified/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-12-02 21:17:54.000000000 +0100
@@ -504,3 +504,7 @@
 EXPORT_SYMBOL(ip_conntrack_chain);
 EXPORT_SYMBOL(ip_conntrack_event_cache);
 #endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+EXPORT_SYMBOL(ip_ct_proto_tcp_set_timeout_syn_received);
+EXPORT_SYMBOL(ip_ct_sd_change_conntrack_info);
+#endif
diff -Nru linux-2.4.28/net/ipv4/netfilter/ip_nat_core.c linux-2.4.28-modified/net/ipv4/netfilter/ip_nat_core.c
--- linux-2.4.28/net/ipv4/netfilter/ip_nat_core.c	2004-12-02 21:22:52.000000000 +0100
+++ linux-2.4.28-modified/net/ipv4/netfilter/ip_nat_core.c	2004-12-02 20:55:46.000000000 +0100
@@ -650,18 +650,6 @@
 		place_in_hashes(conntrack, info);
 	}
 
-#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
-	/* initialize SYNDIS translation of sequence number. Use is specific to SYNDIS module
-	 * and these are not used by any other module. */
-	unsigned int j;
-	for (j=0; j<IP_NAT_MAX_MANIPS; j++)
-	{
-		conntrack->nat.info.manips[j].manip.u.tcp.seq_offset = 0;
-		conntrack->nat.info.manips[j].manip.u.tcp.ts_offset  = 0;
-	}
-#endif	
-	
-	
 	return NF_ACCEPT;
 }
 
diff -Nru linux-2.4.28/net/ipv4/netfilter/ip_nat_proto_tcp.c linux-2.4.28-modified/net/ipv4/netfilter/ip_nat_proto_tcp.c
--- linux-2.4.28/net/ipv4/netfilter/ip_nat_proto_tcp.c	2002-11-29 00:53:15.000000000 +0100
+++ linux-2.4.28-modified/net/ipv4/netfilter/ip_nat_proto_tcp.c	2004-12-02 21:26:10.000000000 +0100
@@ -81,16 +81,114 @@
 	struct tcphdr *hdr = (struct tcphdr *)((u_int32_t *)iph + iph->ihl);
 	u_int32_t oldip;
 	u_int16_t *portptr;
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+	u_int32_t *seq_nbr, *sack_field, new_seq, *ts_field, new_ts;
+	int		   i, j;
+	u_int8_t  *stop, *tcpopt;
+#endif	
 
 	if (maniptype == IP_NAT_MANIP_SRC) {
 		/* Get rid of src ip and src pt */
 		oldip = iph->saddr;
 		portptr = &hdr->source;
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+		seq_nbr = &hdr->seq;
+#endif
 	} else {
 		/* Get rid of dst ip and dst pt */
 		oldip = iph->daddr;
 		portptr = &hdr->dest;
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+		seq_nbr = &hdr->ack_seq;
+#endif	
 	}
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+	if (manip->u.tcp.seq_offset != 0)
+	{
+		/* Takes care about seq number. */
+		new_seq = ntohl(*seq_nbr);
+		new_seq += manip->u.tcp.seq_offset;
+		new_seq = htonl(new_seq);
+		hdr->check = ip_nat_cheat_check(~oldip, manip->ip,
+					 ip_nat_cheat_check(*portptr ^ 0xFFFF, manip->u.tcp.port,
+					 ip_nat_cheat_check(~(*seq_nbr) , new_seq, hdr->check)));
+		*seq_nbr = new_seq;
+		*portptr = manip->u.tcp.port;			
+
+		/* Look is sack option and timestamps are present. If one of them is, translate it too. */
+		sack_field = NULL;
+		ts_field   = NULL;
+		i=0;
+		tcpopt = (u_int8_t *)hdr + 20;
+		stop = (u_int8_t *)hdr + 4*hdr->doff;
+		while (tcpopt < stop) /* = while tcpopt is not at the last byte
+							   *   of the tcp options */
+		{
+			/* The next operations decode the options byte after byte*/
+			switch (*tcpopt)
+			{
+				case 1: /* no operation */
+					tcpopt++;
+				break;
+				
+				case 5: /* TCPOPT_SACK */
+					tcpopt++; 
+					i = *tcpopt - 2;
+					tcpopt++; 
+					sack_field = (u_int32_t*)tcpopt;
+					//tcpopt = stop; /* exit from loop */
+				break;
+				
+				case 8:  /* timestamps, option is 10 byte long */
+					/* If timestamps used, they have to be translated too. */
+					if (manip->u.tcp.ts_offset != 0)
+					{
+						if (maniptype == IP_NAT_MANIP_SRC)
+						{
+							tcpopt+=2;
+							ts_field = (u_int32_t*)tcpopt;
+							tcpopt+=8; /* next option */
+						}
+						else
+						{
+							tcpopt+=6;
+							ts_field = (u_int32_t*)tcpopt;
+							tcpopt+=4; /* next option */
+						}
+						new_ts = ntohl(*ts_field);
+						new_ts += manip->u.tcp.ts_offset;
+						new_ts = htonl(new_ts);
+						hdr->check = ip_nat_cheat_check(~oldip, manip->ip,
+									 ip_nat_cheat_check(~(*ts_field) , new_ts, hdr->check));
+						*ts_field = new_ts;
+					}
+					break;
+				
+				default: /* skip the unknown option */
+					tcpopt++; /* jump to option length field */
+					tcpopt += *tcpopt - 1; /* jump to the end of the option */
+				break;
+			}
+		}
+	
+		/* Fix me: verify if there is not a bug here...
+		   manip->u.tcp.seq_offset is in host byte order, sack_field in network order I presume. */
+		if ( maniptype == IP_NAT_MANIP_DST && sack_field != NULL)
+		{
+			i /= 4;
+			
+			for (j=0; j<i; j++)
+			{
+				hdr->check = ip_nat_cheat_check(~oldip, manip->ip,
+							 ip_nat_cheat_check(~(*sack_field) , *sack_field + manip->u.tcp.seq_offset, hdr->check));
+				*sack_field += manip->u.tcp.seq_offset;
+				sack_field++;
+			}
+		}
+	}
+	else
+	{
+#endif
 
 	/* this could be a inner header returned in icmp packet; in such
 	   cases we cannot update the checksum field since it is outside of
@@ -103,6 +201,9 @@
 	}
 
 	*portptr = manip->u.tcp.port;
+#if defined(CONFIG_IP_NF_TARGET_SYNDIS) || defined(CONFIG_IP_NF_TARGET_SYNDIS_MODULE)
+	}
+#endif
 }
 
 static unsigned int
diff -Nru linux-2.4.28/net/ipv4/netfilter/ipt_SYNDIS.c linux-2.4.28-modified/net/ipv4/netfilter/ipt_SYNDIS.c
--- linux-2.4.28/net/ipv4/netfilter/ipt_SYNDIS.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.4.28-modified/net/ipv4/netfilter/ipt_SYNDIS.c	2004-05-27 14:31:09.000000000 +0200
@@ -0,0 +1,1147 @@
+/* SYN-distributor functionnality support */
+
+/* So far, this code is only a test implementation to validate the idea in:
+ * "Distributed Defense Against Low-Bandwidth TCP SYN Flooding Attacks", Emmanuel
+ * Guiton (that's me), to be published (I wish).
+ */
+
+/* First "fix me":
+ * A few elements in the following list may be out of date (already fixed) or
+ * may state wrong things. All my apologizes and you can fix them as a first 
+ * "fix me".
+ */
+/* Fix me:
+ * - Like it is coded now, only one SYNDIS target can be used at a time.
+ *   Also the target MUST BE specified as an <IP address, port number> pair.
+ *   The check is not performed, but doing otherwise would trigger bugs.
+ * - A lot of tings may have to be thought again. I added support for a lot
+ *   of things while I was coding without having thought at them at first.
+ *   Thus it's very messy and not optimized at all. Look at ip_conntrack_tcp.h
+ *   and you will get my point. The main problem is how to efficiently track
+ *   options so that they can be replayed if needed afterwards.
+ *   A lot of memory may have to be saved by optimization!!
+ * - When a connection is assured, instead of closing the connection established
+ *   with a relay, resetting it could save a few messages. Thus it would lighten
+ *   the traffic load in the local network.
+ * - length of time to wait before drop connection under TCP SYN attack
+ *   is not reliable... thus it affects a lot the effectiveness of the
+ *   program.
+ * - Many error or special cases are skipped.
+ * - Review the locks.
+ * - the module suppose ethernet is the link level protocol in use.
+ * - add support of more TCP options, and think again the way I did it.
+ * - check the size of the first SYN packet. A SYN packet cannot carry any data,
+ *   but I do not check it in this module. If such a packet arrives here, the
+ *   module is abused and the packet is recorded. Thus it could result in a high
+ *   consumption of memory.
+ * - I record TCP SYN packets to replay them afterwards but that is a wrong
+ *   method. Only information that cannot be found without the information in
+ *   the first packet should be recorded. I.e. IP addresses, TCP ports... like
+ *   most of the header fields do not need to be recorded and should not. I had
+ *   written a version respecting that and I stupidly changed it for the current
+ *   solution thinking about a code optimization at that time. It was wrong
+ *   since I was recording connection specific information in variables placed
+ *   in the SYNDIS module (thus only one connection at a time would have been
+ *   possible...). I change this back if I have time for it.
+ * - the sequence number translation as done in the nat helper does not fit the
+ *   one we do here; but maybe an optimized solution that could be used in both
+ *   cases could be found.
+ * - clean the operations on the sk_buff: no doubt a few of them are useless.
+ * - possible loss of packet during the SYNDIS operatons is not take into account.
+ * - optimization: - instead of closing connection to relay, reset it: less packets
+ *                   will travel on the local network.
+ *                 - record IP addresses for which connections have laready been
+ *                   assured. (E.g: if HTTP it's useless to perform the check for
+ *                   each new request.)
+ * - using RST message: adding a rule so that the relay can not send messages
+ *   outside the firewall can be a good idea: If the RST message is lost, the relay
+ *   will send again its SYN ACK message and the sender will get it. (it should omly
+ *   trigger an additional RST anyway)
+ * - the timeout mechanism (to decrease syndis counters) is not precise at all! When
+ *   one retransmission only is set to the tcp_synack_ratries varaible, the timeout is
+ *   normally 9s. Using 9s in SYNDIS, the queues on relays were half empty 50% of the
+ *   time. I got better performances setting the timeouts for SYNDIS at 6s.
+ */
+
+
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/netfilter_ipv4/ip_nat_rule.h>
+#include <linux/netfilter_ipv4/ipt_SYNDIS.h>
+#include <linux/notifier.h>
+#include <net/ip.h>
+#include <net/tcp.h>
+#include <net/route.h>
+
+/* Protects conntrack */
+static DECLARE_RWLOCK(syndis_conntrack_lock);
+
+
+/*------------------- global variables and macros --------------------*/
+
+/* Used to refresh timeout value of syn ack */
+#define SECS *HZ
+
+/* This table indicates the number of half-open connections for each
+ * of the hosts in the struct ipt_sd_data from the user space.
+ * ipt_syndis_counters[0] is the defended host, counters for the
+ * relays come next. */
+/* Fix me:
+ * I do not like this because the size is fixed while in theory the number
+ * of relays can vary as much as one likes. This is an old problem,
+ * see the user space code about syndis. */ 
+static unsigned int	ipt_sd_syndis_counters[16];
+
+/* Contains the target's IP address in network byte order given
+ * by the user data from iptables user-space program.
+ */
+static u_int32_t ipt_sd_ip_target;
+
+/* Stores the defended TCP port number */	
+static u_int16_t ipt_sd_tcpport_target = 0;
+
+/* A few TCP flags used in this module */
+enum ipt_sd_tcpflag
+{
+	IPT_SD_FINACK,
+	IPT_SD_ACK,
+	IPT_SD_RST
+};
+
+/* ---------- THE "MOVING ESTABLISHED CONNECTIONS" PART ---------- */
+
+/* function used to generate TCP packets. */
+static int ipt_sd_send_tcp_pkt(u_int32_t ip_src, u_int32_t ip_dst, u_int32_t syn_seq, u_int32_t ack_seq,
+						u_int16_t port_src, u_int16_t port_dst, enum ipt_sd_tcpflag flag,
+						struct ip_conntrack *conntrack)
+{
+	struct sk_buff	 *skb;
+	u_int8_t 		 *eth;
+	struct tcphdr	 *tcph;
+	struct iphdr	 *iph;
+	u_int8_t		  eth_content[14];
+	struct rtable	 *rt;
+	int				  packet_sent, options_length;
+	u_int8_t		 *tcp_options;
+	u_int32_t		  longword;
+	u_int8_t		  i, byte, j;
+	struct timeval	  nyt;
+	
+	/* SKB INITIALIZATION */
+		/* tcp options (+PAD) are of variable length, which has to be calculated
+		 * before to allocate memory for the whole ethernet frame. */
+	options_length = 4*conntrack->proto.tcp.last_doff-sizeof(struct tcphdr);
+
+	skb = alloc_skb(36 + sizeof(struct tcphdr) + options_length, GFP_ATOMIC);
+		/* Reserve 2 bytes at the start of the packet before the 14 byte long
+		 * ethernet header. Why? Because performances are better on many
+		 * architectures if the IP header is 16 bytes aligned. 
+		 */
+	skb_reserve(skb, 2);
+		/* Now, set the three headers place in the packet.*/
+		/* eth, iph and tcph are put one after the other. */
+		/* ethernet header is 14 byte long */
+	eth = (u_int8_t *) skb_put(skb, 14);
+		/* ip header is 20 byte long */
+	iph = (struct iphdr *)skb_put(skb, sizeof(struct iphdr));
+		/* tcp header is sizeof(struct tcphdr) byte long (=20) */
+	tcph = (struct tcphdr *)skb_put(skb, sizeof(struct tcphdr));
+		/* length of tcp options has been calculated */
+	tcp_options = (u_int8_t *)skb_put(skb, options_length);
+
+	/* skb->dst AND skb->dev (the latter is set by the former) */
+	if (ip_route_output(&rt, ip_dst, 0, 0, 0) != 0)
+	{
+		printk("ipt_SYNDIS: ip_route_output failed.\n");
+		return -1;
+	}
+	skb->dst = (struct dst_entry *) rt; /* A trick from ip_route_input in route.c */
+	skb->dev = skb->dst->dev;
+
+	/* TRANSPORT HEADER: TCP */
+		/* First, fill in the TCP data. */
+	tcph->source  = port_src;
+	tcph->dest	  = port_dst;
+	tcph->seq	  = syn_seq;
+	tcph->ack_seq = ack_seq;
+		/* Fix me:
+	     * Window should be slected in function of its size in the previous
+	     * messages between the client in the public network and the relay. 
+	     */
+		/* For the tests, fixed size(5840 = window size of my sender,
+		 * as observed from tcpdump logs).*/
+	tcph->window  = htons(5840);
+	tcph->urg_ptr = 0;
+		/* TCP flags */
+	tcph->cwr = 0;
+	tcph->ece = 0;
+	tcph->urg = 0;
+	tcph->psh = 0;
+	tcph->rst = 0;
+	tcph->syn = 0;
+	tcph->fin = 0;
+	tcph->ack = 0;
+	
+	if (flag==IPT_SD_FINACK)
+	{
+		tcph->fin = 1;
+		tcph->ack = 1;
+	}
+	if (flag==IPT_SD_ACK)
+		tcph->ack = 1;
+	
+	if (flag==IPT_SD_RST)
+		tcph->rst = 1;
+	
+		/* length of TCP options, 4 byte aligned */
+	tcph->doff = 5 + (options_length / 4);
+	if (options_length % 4 != 0)
+		tcph->doff++;
+
+		/* TCP options*/
+	if (tcph->doff > 5)
+	{
+		i=0;
+		while (i<(4*tcph->doff-sizeof(struct tcphdr)))
+		{
+			/* The next operations decode the options byte after byte*/
+			longword = conntrack->proto.tcp.original_opts[i/4];
+			longword >>= 8*(i%4);
+			byte = (u_int8_t)longword;
+			switch (byte)
+			{
+				case 1:/*no operation*/
+					i++;
+				break;
+				
+				case 8: /*timestamps, option is 10 byte long */
+					i += 2; /* jump to first timestamp*/
+					/* update source timestamp */
+					if (i%4 != 0)
+					{
+						printk("ipt_SYNDIS: error when reading TCP options; timestamp is not 4 byte aligned.\n");
+					}
+					if (flag == IPT_SD_FINACK || flag == IPT_SD_RST)
+					{
+						WRITE_LOCK(&syndis_conntrack_lock);
+						/* Record the original ack timestamp (now, it is the first time we access it). */
+						conntrack->proto.tcp.original_ack_timestamp = conntrack->proto.tcp.original_opts[i/4];
+						/* Idem reply timestamp, we need it for the calculations when translating timestamps
+						 * (see restore_the_connection function.) */
+						conntrack->proto.tcp.reply_ack_timestamp = conntrack->proto.tcp.original_opts[(i+4)/4];
+						WRITE_UNLOCK(&syndis_conntrack_lock);
+					}
+					do_gettimeofday(&nyt);
+					longword = ntohl(100 * (nyt.tv_sec - conntrack->proto.tcp.original_ack_time.tv_sec)
+						+ (nyt.tv_usec/10000 - conntrack->proto.tcp.original_ack_time.tv_usec/10000));
+					longword += conntrack->proto.tcp.original_ack_timestamp;
+					WRITE_LOCK(&syndis_conntrack_lock);
+					conntrack->proto.tcp.original_opts[i/4] = longword;
+					WRITE_UNLOCK(&syndis_conntrack_lock);
+					i += 4;/* jump to second timestamp */
+					
+					/* find receiver timestamp to be acknowledged.
+					 * (valid because all packets sent by this function have ACK set) */
+					j = 0;
+					while (j<(4*conntrack->proto.tcp.rcvr_doff-sizeof(struct tcphdr)))
+					{
+						/* The next operations decode the receiver options byte after byte
+						 * and stop when timestamp option is found. */
+						byte = 1;
+						while (byte == 1)
+						{
+							longword = conntrack->proto.tcp.reply_opts[j/4];
+							longword >>= 8*(j%4);
+							byte = (u_int8_t)longword;
+							j++;
+						}
+						if (byte == 8)
+						{
+							j += 2; /* jump to the timestamp */
+							/* update acknowledged timestamp in original direction */
+							WRITE_LOCK(&syndis_conntrack_lock);
+							conntrack->proto.tcp.original_opts[i/4] = conntrack->proto.tcp.reply_opts[j/4];
+							WRITE_UNLOCK(&syndis_conntrack_lock);
+							/* we found what we wanted; exit. */
+							j = 4*conntrack->proto.tcp.rcvr_doff - sizeof(struct tcphdr); 
+						}
+						else
+						{
+							j++; /* jump to option length field */
+							longword = conntrack->proto.tcp.reply_opts[j/4];
+							longword >>= 8*(j%4); /* one byte switch*/
+							byte = (u_int8_t)longword; /* here is the length of the option */ 
+							j += byte - 1; /* jump to the end of the option */
+						}
+					}
+					i += 4;/* jump to next option */
+				break;
+				
+				default:
+					printk("ipt_SYNDIS: TCP option has not been recognized.\n");
+				return -1;
+			}
+		}
+		WRITE_LOCK(&syndis_conntrack_lock);
+		memcpy(tcp_options, conntrack->proto.tcp.original_opts, options_length);
+		WRITE_UNLOCK(&syndis_conntrack_lock);
+	}
+	
+		/* TCP checksum */
+	tcph->check	  = 0;
+	tcph->check	  = tcp_v4_check(tcph, 20 + options_length, ip_src, ip_dst,
+								 csum_partial((char *)tcph, 20 + options_length, 0));
+									 
+	/* NETWORK HEADER: IP */
+	iph->ihl	  = 5;
+	iph->version  = 4;
+		/* substract one to the TTL because we are a node on the path */
+	iph->ttl	  = ((struct iphdr *)conntrack->proto.tcp.ipt_sd_original_syn_packet)->ttl - 1;
+	iph->tos	  = 0;
+	iph->protocol = IPPROTO_TCP;
+	iph->saddr	  = ip_src;
+	iph->daddr	  = ip_dst;
+	if (conntrack->proto.tcp.ip_df == 1)
+		iph->frag_off = htons(IP_DF);
+	else
+		iph->frag_off = 0;
+	/* We have to increment the ip identifier number. */
+	iph->id = htons(ntohs(((struct iphdr *)conntrack->proto.tcp.ipt_sd_original_syn_packet)->id) + 1);
+	
+		/* IP length = IP header + TCP header (+ options) + no data */
+	iph->tot_len  = htons(40 + options_length);
+	iph->check	  = 0;
+	iph->check	  = ip_fast_csum((void *) iph, iph->ihl);
+
+	/* LINK HEADER: ETHERNET */
+		/* Find the hardware address of the destination. */
+	if (arp_find(eth_content, skb))
+	{
+		printk("ipt_SYNDIS: Did not find the hardware address of the remote host.\n");
+		return -1;
+	}
+		/* set up the source MAC address */
+	memcpy(&(eth_content[6]), skb->dev->dev_addr, 6);
+		/* Type code = IP */
+	eth_content[12] = 0x08;
+	eth_content[13] = 0x00;	
+		/* fill the ethernet header in skb */
+	memcpy(eth, eth_content, 14);
+		/* set the ethernet header field */
+	skb->mac.raw = ((u8 *)iph) - 14;
+
+	/* Next is also set by ip_finish_output */
+	skb->protocol = __constant_htons(ETH_P_IP);
+	
+	/* TIMESTAMP */
+		/* last, so it's closest to sending time. */
+	do_gettimeofday(&skb->stamp);
+
+	/* SENDING THE PACKET */
+		/* inspired from pktgen.c */
+	packet_sent=0;
+	while (!packet_sent)
+	{
+		spin_lock_bh(&skb->dev->xmit_lock);
+		if (!netif_queue_stopped(skb->dev))
+		{
+			atomic_inc(&skb->users);
+			if (skb->dev->hard_start_xmit(skb, skb->dev))
+			{
+				atomic_dec(&skb->users);
+				if (net_ratelimit())
+				{
+				   printk("ipt_SYNDIS: Hard xmit error\n");
+				}
+			}
+			else
+			   packet_sent = 1;	
+		}
+		else
+			/* Try it again */
+			packet_sent = 0;
+		spin_unlock_bh(&skb->dev->xmit_lock);
+	}
+	/* skb sent, free it */
+	kfree_skb(skb);
+
+	/* If everything went fine... */
+	return 0;
+}
+
+
+/* send data packet recorded wether in conntrack->proto.tcp.ipt_sd_original_syn_packet
+ * or in conntrack->proto.tcp.ipt_sd_first_data_packet */
+int ipt_sd_send_recorded_packet (struct ip_conntrack *conntrack, u_int8_t flag)
+{
+	struct iphdr   *iph;
+	struct tcphdr  *tcph;
+	u_int8_t       *tcp_payload;
+	struct sk_buff *skb;
+	u_int8_t 	   *skb_eth, *skb_tcp_payload;
+	u_int8_t		skb_eth_content[14];
+	struct iphdr   *skb_iph;
+	struct tcphdr  *skb_tcph;
+	u_int8_t       *tcpopt, *stop, i, byte;
+	u_int32_t      *timestamp, longword;
+	int             packet_sent;
+	struct rtable  *rt;
+	u_int16_t       packet_length;
+	struct timeval  nyt;
+
+	if ( (flag == 0 && conntrack->proto.tcp.ipt_sd_original_syn_packet != NULL)
+		 || (flag !=0 && conntrack->proto.tcp.ipt_sd_first_data_packet != NULL) )
+	{
+		if (flag == 0)
+		{
+			iph           = (struct iphdr *)conntrack->proto.tcp.ipt_sd_original_syn_packet;
+			packet_length = conntrack->proto.tcp.ipt_sd_syn_packet_length;
+		}
+		else
+		{
+			iph           = (struct iphdr *)conntrack->proto.tcp.ipt_sd_first_data_packet;
+			packet_length = conntrack->proto.tcp.ipt_sd_packet_length;
+		}
+				
+		tcph        = (struct tcphdr *)((u_int32_t *)iph + iph->ihl);
+		tcp_payload = (u_int8_t *)((u_int32_t *)tcph + tcph->doff);
+		
+		/* SKB INITIALIZATION */
+			/* size of the ip packet + ethernet header + 2 bytes for 4-byte alignment */
+		skb = alloc_skb(packet_length + 16, GFP_ATOMIC);
+			/* Reserve 2 bytes at the start of the packet before the 14 byte long
+			 * ethernet header. Why? Because performances are better on many
+			 * architectures if the IP header is 4-byte aligned. 
+			 */
+		skb_reserve(skb, 2);
+			/* Now, set the three headers place in the packet.*/
+			/* eth, iph and tcph are put one after the other. */
+			/* ethernet header is 14 byte long */
+		skb_eth = (u_int8_t*) skb_put(skb, 14);
+			/* ip header is 20 byte long */
+		skb_iph = (struct iphdr *)skb_put(skb, 4*iph->ihl);
+			/* tcp header and data length is found from recorded data */
+		skb_tcph = (struct tcphdr *)skb_put(skb, 4*tcph->doff);
+			/* data (= TCP payload) */
+		skb_tcp_payload = (u_int8_t *)skb_put(skb, packet_length - 4*(iph->ihl + tcph->doff));
+		
+		/* skb->dst AND skb->dev (the latter is set by the former) */
+		if (ip_route_output(&rt, iph->daddr, 0, 0, 0) != 0)
+		{
+			printk("ipt_SYNDIS: ip_route_output failed.\n");
+			return -1;
+		}
+		skb->dst = (struct dst_entry *) rt; /* A trick from ip_route_input in route.c */
+		skb->dev = skb->dst->dev;
+	
+		/* DATA (TCP PAYLOAD)*/
+		memcpy(skb_tcp_payload, tcp_payload, packet_length - 4*(iph->ihl + tcph->doff));
+		
+		/* NETWORK HEADER: IP */
+		memcpy(skb_iph, iph, 4*iph->ihl);
+		skb_iph->ttl--;
+		skb_iph->check = 0;
+		skb_iph->check = ip_fast_csum((void *) skb_iph, skb_iph->ihl);
+		
+		/* TRANSPORT HEADER: TCP */
+		memcpy(skb_tcph, tcph, 4*tcph->doff);
+		
+		/* Not modifying the timestamp of the SYN packet avoids to recompile the
+		 * checksum etc: it's simpler. It also helps the target to consider that
+		 * the sender is far when calculating the RTT (even if anyway the
+		 * measurements will be misleaded because of SYNDIS operations. If
+		 * someone is interested, he/she can study the effect of SYNDIS on that. */
+		if (flag == 1)
+		{
+				/* replaces timestamps with previous ones if timestamps are used. */
+			if (tcph->doff > 5)
+			{
+				stop = tcpopt = (u_int8_t *)skb_tcph + 20;
+				stop += 4*skb_tcph->doff;
+				timestamp = NULL;
+				while (tcpopt < stop) /* = while tcpopt is not at the last byte
+									   *   of the tcp options */
+				{
+					/* The next operations decode the options byte after byte*/
+					switch (*tcpopt)
+					{
+						case 1: /* no operation */
+							tcpopt++;
+						break;
+						
+						case 8: /* timestamps, option is 10 byte long */
+							tcpopt += 2; /* jump to first timestamp */
+							timestamp = (u_int32_t *) tcpopt;
+							tcpopt = stop; /* exit from loop */
+						break;
+						
+						default: /* skip the unknown option */
+							tcpopt++; /* jump to option length field */
+							tcpopt += *tcpopt - 1; /* jump to the end of the option */
+						break;
+					}
+				}
+				
+				if (timestamp != NULL)
+				{
+					/* Timestamp of that packet */
+					do_gettimeofday(&nyt);
+					*timestamp  = conntrack->proto.tcp.original_ack_timestamp;
+					*timestamp += ntohl(100 * (nyt.tv_sec - conntrack->proto.tcp.original_ack_time.tv_sec)
+						+ (nyt.tv_usec/10000 - conntrack->proto.tcp.original_ack_time.tv_usec/10000));
+					
+					/* Acknowledged timestamp */
+					timestamp++;
+					if (tcph->ack) /* receiver timestamp is valid field only if ACK is set. */
+					{
+						/* find receiver timestamp to be acknowledged. */
+						i = 0;
+						while (i<(4*conntrack->proto.tcp.rcvr_doff-sizeof(struct tcphdr)))
+						{
+							/* The next operations decode the receiver options byte after byte
+							 * and stop when timestamp option is found. */
+							byte = 1;
+							while (byte == 1)
+							{
+								longword = conntrack->proto.tcp.reply_opts[i/4];
+								longword >>= 8*(i%4);
+								byte = (u_int8_t)longword;
+								i++;
+							}
+							if (byte == 8)
+							{
+								i += 2; /* jump to the timestamp */
+								/* update acknowledged timestamp in original direction */
+								*timestamp = conntrack->proto.tcp.reply_opts[i/4];
+								/* we found what we wanted; exit. */
+								i = 4*conntrack->proto.tcp.rcvr_doff - sizeof(struct tcphdr); 
+							}
+							else
+							{
+								i++; /* jump to option length field */
+								longword = conntrack->proto.tcp.reply_opts[i/4];
+								longword >>= 8*(i%4); /* one byte switch*/
+								byte = (u_int8_t)longword; /* here is the length of the option */ 
+								i += byte - 1; /* jump to the end of the option */
+							}
+						}
+					}
+				}
+				
+					/* change acknowledgement */
+				if (flag != 0) /* Otherwise: SYN packet, no valid ack_seq */
+					skb_tcph->ack_seq = conntrack->proto.tcp.new_handshake_ack;
+				
+					/* TCP checksum */
+				skb_tcph->check	  = 0;
+				skb_tcph->check	  = tcp_v4_check(skb_tcph, packet_length - 4*(skb_iph->ihl), skb_iph->saddr, skb_iph->daddr,
+											 csum_partial((char *)skb_tcph, packet_length - 4*(skb_iph->ihl), 0));
+			}
+		}
+
+		/* LINK HEADER: ETHERNET */
+			/* Find the hardware address of the destination. */
+		arp_find(skb_eth_content, skb);
+			/* set up the source MAC address */
+		memcpy(&(skb_eth_content[6]), skb->dev->dev_addr, 6);
+			/* Type code = IP */
+		skb_eth_content[12] = 0x08;
+		skb_eth_content[13] = 0x00;	
+			/* fill the ethernet header in skb */
+		memcpy(skb_eth, skb_eth_content, 14);
+			/* set the ethernet header field */
+		skb->mac.raw = ((u8 *)iph) - 14;
+	
+		/* Next is also set by ip_finish_output */
+		skb->protocol = __constant_htons(ETH_P_IP);
+		
+		/* TIMESTAMP */
+			/* last, so it's closest to sending time. */
+		do_gettimeofday(&skb->stamp);
+	
+		/* SENDING THE PACKET */
+			/* inspired from pktgen.c */
+		packet_sent = 0;
+		while (!packet_sent)
+		{
+			spin_lock_bh(&skb->dev->xmit_lock);
+			if (!netif_queue_stopped(skb->dev))
+			{
+				atomic_inc(&skb->users);
+				if (skb->dev->hard_start_xmit(skb, skb->dev))
+				{
+					atomic_dec(&skb->users);
+					if (net_ratelimit())
+					{
+					   printk("ipt_SYNDIS: Hard xmit error\n");
+					}
+				}
+				else
+				   packet_sent = 1;	
+			}
+			else
+				/* Try it again */
+				packet_sent = 0;
+			spin_unlock_bh(&skb->dev->xmit_lock);
+		}
+
+		/* skb sent, free it */
+		kfree_skb(skb);
+		/* should free also memory of ipt_sd_first_data_packet so we do not need
+		 * kfree(ipt_sd_first_data_packet); */
+
+		/* Do not need the packet anymore, free the memory.
+		 * Important to do it as many may have to be recorded. Save the memory. */
+		WRITE_LOCK(&syndis_conntrack_lock);
+		if (flag == 0)
+			kfree(conntrack->proto.tcp.ipt_sd_original_syn_packet);
+		else
+			kfree(conntrack->proto.tcp.ipt_sd_first_data_packet);
+		WRITE_UNLOCK(&syndis_conntrack_lock);
+	}
+	
+	/* Kaikki hyvin? */
+	return 0;
+}
+
+/* restore the tracking of the newly moved connection and set the
+ * translation of the sequence numbers. */
+static int ipt_sd_restore_the_connection(struct ip_conntrack *conntrack)
+{
+	u_int8_t  *tcpopt, *stop;
+	u_int32_t *timestamp;
+
+	WRITE_LOCK(&syndis_conntrack_lock);
+	/* sequence number from target is different than the one from relay.
+	 * Thus it has to be translated too.
+	 * Mechanism: offset is always added, + or - is performed thanks to the modulo 2^32. */ 
+	if (conntrack->proto.tcp.new_handshake_ack < conntrack->proto.tcp.handshake_ack)
+	{
+		conntrack->nat.info.manips[0].manip.u.tcp.seq_offset = 4294967296 /* 2^32 */ + ntohl(conntrack->proto.tcp.new_handshake_ack) - ntohl(conntrack->proto.tcp.handshake_ack);
+		conntrack->nat.info.manips[1].manip.u.tcp.seq_offset = ntohl(conntrack->proto.tcp.handshake_ack) - ntohl(conntrack->proto.tcp.new_handshake_ack);
+	}
+	else
+	{
+		conntrack->nat.info.manips[0].manip.u.tcp.seq_offset = ntohl(conntrack->proto.tcp.new_handshake_ack) - ntohl(conntrack->proto.tcp.handshake_ack);
+		conntrack->nat.info.manips[1].manip.u.tcp.seq_offset = 4294967296 /* 2^32 */ + ntohl(conntrack->proto.tcp.handshake_ack) - ntohl(conntrack->proto.tcp.new_handshake_ack);
+	}
+	WRITE_UNLOCK(&syndis_conntrack_lock);
+	
+	/* Same thing for the timestamps if they are present. */
+	/* First: find the receiver timestamp, if it exists */
+	stop = tcpopt = conntrack->proto.tcp.reply_opts;
+	stop += 4*conntrack->proto.tcp.rcvr_doff;
+	timestamp = NULL;
+	while (tcpopt < stop) /* = while tcpopt is not at the last byte
+						   *   of the tcp options */
+	{
+		/* The next operations decode the options byte after byte*/
+		switch (*tcpopt)
+		{
+			case 1: /* no operation */
+				tcpopt++;
+			break;
+			
+			case 8: /* timestamps, option is 10 byte long */
+				tcpopt += 2; /* jump to first timestamp */
+				timestamp = (u_int32_t *) tcpopt;
+				tcpopt = stop; /* exit from loop */
+			break;
+			
+			default: /* skip the unknown option */
+				tcpopt++; /* jump to option length field */
+				tcpopt += *tcpopt - 1; /* jump to the end of the option */
+			break;
+		}
+	}
+	/* Now, if timestamp present: calculate offset. */
+	if (timestamp != NULL)
+	{
+		WRITE_LOCK(&syndis_conntrack_lock);
+		if (*timestamp < conntrack->proto.tcp.reply_ack_timestamp)
+		{
+			conntrack->nat.info.manips[0].manip.u.tcp.ts_offset = 4294967296 /* 2^32 */ + ntohl(*timestamp) - ntohl(conntrack->proto.tcp.reply_ack_timestamp);
+			conntrack->nat.info.manips[1].manip.u.tcp.ts_offset = ntohl(conntrack->proto.tcp.reply_ack_timestamp) - ntohl(*timestamp);
+		}
+		else
+		{
+			conntrack->nat.info.manips[0].manip.u.tcp.ts_offset = ntohl(*timestamp) - ntohl(conntrack->proto.tcp.reply_ack_timestamp);
+			conntrack->nat.info.manips[1].manip.u.tcp.ts_offset = 4294967296 /* 2^32 */ + ntohl(conntrack->proto.tcp.reply_ack_timestamp) - ntohl(*timestamp);
+		}
+		WRITE_UNLOCK(&syndis_conntrack_lock);
+	}
+	
+	/* Send the recorded data packet if present. */
+	ipt_sd_send_recorded_packet(conntrack, 1);	
+
+	WRITE_LOCK(&syndis_conntrack_lock);
+	conntrack->proto.tcp.freeze_state = 0;
+	conntrack->proto.tcp.syndis_on    = 0;
+	WRITE_UNLOCK(&syndis_conntrack_lock);
+	return 0;
+}
+
+
+/* moves a connection established with a relay to the target.*/
+static int ipt_sd_move_the_connection(struct ip_conntrack *conntrack)
+{
+	/* Change the NAPT information so that messages are directed to the target
+	 * instead of the relay. It also changes the conntrack information so that
+	 * messages coming from the target are tracked instead of the messages
+	 * coming from the relay.*/
+	WRITE_LOCK(&syndis_conntrack_lock);
+	conntrack->nat.info.manips[0].manip.ip         = ipt_sd_ip_target;
+	conntrack->nat.info.manips[0].manip.u.tcp.port = ipt_sd_tcpport_target;
+	WRITE_UNLOCK(&syndis_conntrack_lock);
+	
+	if (ip_ct_sd_change_conntrack_info(conntrack, ipt_sd_ip_target, ipt_sd_tcpport_target) == -1)
+	{
+		printk("ipt_SYNDIS: error when modifying conntrack information.\n");
+		return -1;
+	}
+
+	/* Send TCP SYN packet. */
+	if (ipt_sd_send_recorded_packet(conntrack, 0) < 0)
+	{
+		printk("ipt_SYNDIS: Error sending TCP SYN packet!\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+/* send FIN message to old connection */
+static int ipt_sd_close_old_connection(struct ip_conntrack *conntrack)
+{
+	
+	if ( ipt_sd_send_tcp_pkt( conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip,
+					   conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip,
+					   htonl(ntohl(conntrack->proto.tcp.handshake_seq)+1),
+					   conntrack->proto.tcp.handshake_ack,
+					   conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.tcp.port,
+					   conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.tcp.port,
+					   IPT_SD_RST,
+					   conntrack
+					 ) < 0)
+	{
+		printk("ipt_SYNDIS: Sending TCP RST packet failed.\n");
+		return -1;
+	}
+	ipt_sd_move_the_connection(conntrack);
+	
+	/* Next is for using normal TCP end of connection instead of RST. */
+	/*
+	if ( ipt_sd_send_tcp_pkt( conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip,
+					   conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip,
+					   htonl(ntohl(conntrack->proto.tcp.handshake_seq)+1),
+					   conntrack->proto.tcp.handshake_ack,
+					   conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.tcp.port,
+					   conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.tcp.port,
+					   IPT_SD_FINACK,*/ /*FIN ACK because this is also the third message of the handshake*/
+/*					   conntrack
+					 ) < 0)
+	{
+		printk("ipt_SYNDIS: Sending TCP FINACK packet failed.\n");
+		return -1;
+	}*/
+	
+	return 0;
+}
+
+
+/* -------------- THE "NETFILTER OPERATIONS" PART --------------- */
+
+/*------------------- target operations --------------------*/
+
+/* - table must be nat
+ * - hook must be PREROUTING
+ * - protocol must be TCP
+ * - Fix me: anything else? please, do.
+ */
+
+static int
+ipt_syndis_check(const char *tablename,
+	       const struct ipt_entry *e,
+	       void *targinfo,
+	       unsigned int targinfosize,
+	       unsigned int hook_mask)
+{
+	int i;
+	
+	/* Check nat table. */
+	if (strcmp(tablename, "nat") != 0) {
+		printk("ipt_SYNDIS: bad table `%s'.\n", tablename);
+		return 0;
+	}
+
+	/* Check PREROUTING hook */
+	if ((hook_mask & ~(1 << NF_IP_PRE_ROUTING)) != 0)
+	{
+		printk("ipt_SYNDIS: only supported in PREROUTING hook.\n");
+		return 0;
+	}
+	
+	/* Check TCP protocol */
+	if (e->ip.proto != IPPROTO_TCP)
+	{
+		printk("ipt_SYNDIS: only works with the TCP protocol.\n");
+		return 0;
+	}
+
+	/* Initialize ipt_syndis_counter here so that it's reseted each
+	 * time the user enter the SYNDIS target. */
+	for (i=0;i<16;i++)
+		ipt_sd_syndis_counters[i]=0;
+	
+	/* Initialize content of data from userspace program. */
+	ipt_sd_ip_target = e->ip.dst.s_addr;
+
+	return 1; /* Rule accepted. */
+}
+
+
+static unsigned int
+ipt_syndis_target(struct sk_buff **pskb,
+		unsigned int hooknum,
+		const struct net_device *in,
+		const struct net_device *out,
+		const void *targinfo,
+		void *userinfo)
+{
+	const struct ipt_sd_data   *sd_data;
+	struct ip_conntrack		   *conntrack;
+	enum ip_conntrack_info		ctinfo;
+	int							i, nbr_relays, j;
+	struct ip_nat_multi_range	newrange;
+	u_int32_t					new_ip_target;
+	u_int16_t					new_tcp_port;
+	
+	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING);
+	sd_data = targinfo;
+	
+	conntrack = ip_conntrack_get(*pskb, &ctinfo);
+
+	if (conntrack->ipt_sd_syndis_counter != NULL)
+	{
+		printk("ipt_SYNDIS: WARNING! syndis_counter not correctly initialized in connection tracking core code!\n");
+		return NF_DROP;
+	}
+		
+	/* Could be better initialized in the previous funciton from info from user space*/
+	ipt_sd_tcpport_target = conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.tcp.port;
+	/* If the next variable is set to 1, this indicates that the SYNDIS mechanism is
+	 * active on that connection. Useful in the conntrack code. */
+	WRITE_LOCK(&syndis_conntrack_lock);
+	conntrack->proto.tcp.syndis_on			= 0;
+	conntrack->proto.tcp.freeze_state		= 0;
+	WRITE_UNLOCK(&syndis_conntrack_lock);
+	nbr_relays=0;
+	while (nbr_relays<15 && sd_data->host_list[nbr_relays].address!=0)
+		nbr_relays++;
+
+	for (i=0;i<nbr_relays+1;i++)
+		printk("%lu  ", ipt_sd_syndis_counters[i]);
+	printk("\n");
+	/* Redirect packet if necessary;
+	 * Set timer according to timeout value of the right host;
+	 */
+	if (ctinfo == IP_CT_NEW)
+	{
+		if (conntrack->proto.tcp.state == TCP_CONNTRACK_SYN_SENT)
+		{
+			/* First, do it on the defended host. If it works: no need for redirection: return NF_ACCEPT;
+			 * keep a margin, only wait that 95% of the backlog queue is full. */
+
+			/* Change the value of the syn_received timeout in ip_conntrack_proto_tcp module */
+			/* Fix me: change target_tcp_timeout for a more clear name. */
+			ip_ct_proto_tcp_set_timeout_syn_received(sd_data->target_tcp_timeout);
+// TEST TEST TEST !!
+//if (ipt_sd_syndis_counters[0] < 0)
+			if (ipt_sd_syndis_counters[0] < sd_data->target_backlog_size)
+			{
+				ipt_sd_syndis_counters[0]++;
+				WRITE_LOCK(&syndis_conntrack_lock);
+				conntrack->ipt_sd_syndis_counter=&(ipt_sd_syndis_counters[0]);
+				WRITE_UNLOCK(&syndis_conntrack_lock);
+				
+				/* Fix me:
+				 * member gua_target in struct ipt_sd_data should be replaced with
+				 * local_target_address. Then, instead of return NF_ACCEPT, do:
+				 *
+				 * newrange= ((struct ip_nat_multi_range)
+				 * {
+				 *		1,
+				 *		{{
+				 *		IP_NAT_RANGE_MAP_IPS,
+				 *		local_target_address,
+				 *		local_target_address,
+				 *		{new_tcp_port},
+				 *		{new_tcp_port}
+				 *		}}
+				 * });
+				 *	
+				 *	return (ip_nat_setup_info(conntrack, &newrange, hooknum));
+				 *
+				 * This will enable to use the address of the NATP router to be
+				 * the address of the website as seen by the users on the public
+				 * network.
+				 * Corresponding modification is also needed in user-space program.
+				 */
+				return NF_ACCEPT;
+			}
+			else
+			{
+				/* Fix me:
+				 * Try every available host which can have still some free space
+				 * If it does not work... well that's bad. Let's drop it for now,
+				 * but another solution can be found as we do not completely use
+				 * the buffer space on the hosts. */
+				/* Note:
+				 * I changed from this idea to an even distribution of SYN requests
+				 * on all the relays. The firewall does not exactly know the backlog
+				 * queue status on the relays; it only calculates from the packets
+				 * it sees. This result in a small difference between the real
+				 * situation and the one calculated by the router. Thus the backlog
+				 * queue usage is not optimal, I've seen variations of a few hundred
+				 * packets instead of having a quite stable queue usage. The way I
+				 * implemented the syndis counter may be a source of delay too.
+				 * Anyway, a even distribution allows to distribute the error margin
+				 * too, resulting in a "better" queue usage (well, nothing from the
+				 * performance point of view, but with the first method you report
+				 * the error from host to host and I think you may end in using one
+				 * more relay while in fact another one has already some space
+				 * available.).
+				 * NB: aditional practice did not convince me that I was right...
+				 * Well... */
+				 /* Additional note:
+				  * I know sometimes my explanations are not very clear... */
+				 
+				i=1;
+				j=0;
+				while (	i < nbr_relays+1)
+				{
+					if (ipt_sd_syndis_counters[i] < sd_data->host_list[i-1].backlog_size)
+					{
+						if (j==0)
+							j=i;
+						else
+						{
+							/* "even" distribution is weighted according to relays' backlog queue sizes */
+							if (10000*ipt_sd_syndis_counters[i]/sd_data->host_list[i-1].backlog_size < 10000*ipt_sd_syndis_counters[j]/sd_data->host_list[j-1].backlog_size)
+							{
+								j=i;
+							}
+						}
+					}					
+					i++;
+				}
+	
+				/* The following should indicate that relays and target do not have anymore place
+				 * in their backlog queue so the packet should be dropped: we cannot do anything
+				 * with it.
+				 * In practice, there is some performance problem that results in relay and target's
+				 * queues emptying faster than SYNDIS expect them to be. Thus, it's better not to
+				 * drop the packet but to redistribute it, the relay or target will discard it if
+				 * it cannot handle it.
+				 * This is also a FIXME. */
+				if (j==0)
+				{
+			//		printk("ipt_SYNDIS: SYN distribution system cannot handle the TCP SYN flow.\n I'm drowning. Farewell world.\n");
+			//		return NF_DROP;
+					i=1;
+					j=1;
+					while (	i < nbr_relays+1)
+					{
+						/* "even" distribution is weighted according to relays' backlog queue sizes */
+						if (10000*ipt_sd_syndis_counters[i]/sd_data->host_list[i-1].backlog_size < 10000*ipt_sd_syndis_counters[j]/sd_data->host_list[j-1].backlog_size)
+						{
+							j=i;
+						}
+						i++;
+					}
+				}
+			//	else /* still space, increment counter and set timer, redirect packet. */
+			//	{
+					new_ip_target = sd_data->host_list[j-1].address;
+					new_tcp_port  = htons(sd_data->host_list[j-1].port);
+					ipt_sd_syndis_counters[j]++;
+					WRITE_LOCK(&syndis_conntrack_lock);
+					conntrack->ipt_sd_syndis_counter = &(ipt_sd_syndis_counters[j]);
+					/* Connection is now actively defended by SYNDIS */
+					conntrack->proto.tcp.syndis_on = 1;
+					/* save the packet = original SYN */
+					conntrack->proto.tcp.ipt_sd_original_syn_packet = kmalloc((*pskb)->len - (*pskb)->data_len,  GFP_ATOMIC);
+					memcpy(conntrack->proto.tcp.ipt_sd_original_syn_packet, (*pskb)->nh.iph, (*pskb)->len - (*pskb)->data_len);
+					conntrack->proto.tcp.ipt_sd_syn_packet_length = (*pskb)->len - (*pskb)->data_len;
+					WRITE_UNLOCK(&syndis_conntrack_lock);
+					/* Fix me: change tcp_timeout for a more clear name. */
+					/* Change the value of the syn_received timeout in ip_conntrack_proto_tcp module */
+					ip_ct_proto_tcp_set_timeout_syn_received(sd_data->host_list[j].tcp_timeout);
+			//	}
+				newrange= ((struct ip_nat_multi_range)
+				{
+					1,
+					{{
+						IP_NAT_RANGE_MAP_IPS | IP_NAT_RANGE_PROTO_SPECIFIED,
+						new_ip_target,
+						new_ip_target,
+						{new_tcp_port},
+						{new_tcp_port}
+					}}
+				});
+					
+				return ip_nat_setup_info(conntrack, &newrange, hooknum);
+			}
+		}
+	}
+	return NF_ACCEPT;
+}
+
+/* new SYNDIS target*/
+static struct ipt_target ipt_syndis_reg
+= { { NULL, NULL }, "SYNDIS", ipt_syndis_target, ipt_syndis_check, NULL, THIS_MODULE };
+
+
+
+/*------------------- notifier operations --------------------*/
+
+static int ipt_syndis_conntrack_event(struct notifier_block *this, unsigned long events, void *ptr)
+{
+	struct ip_conntrack *conntrack = (struct ip_conntrack *)ptr;
+	
+	/* Next is for using normal TCP end of connection instead of RST. */
+	/*	if (((events) & (1 << (IPCT_SD_LAST_FINACK))))
+	{
+		if ( ipt_sd_send_tcp_pkt( conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip,
+						   conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip,
+						   htonl(ntohl(conntrack->proto.tcp.handshake_seq) + 2),
+						   htonl(ntohl(conntrack->proto.tcp.handshake_ack) + 1),
+						   conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.tcp.port,
+						   conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.tcp.port,
+						   IPT_SD_ACK,
+						   conntrack
+						 ) < 0)
+		{
+			printk("ipt_SYNDIS: Sending last ACK packet to close relay connection failed.\n");
+			return -1;
+		}
+		
+		ipt_sd_move_the_connection(conntrack);
+	}*/
+	
+	if (((events) & (1 << (IPCT_SD_LAST_3WH_ACK))))
+	{
+		
+		if ( ipt_sd_send_tcp_pkt( conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip,
+						   conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip,
+						   htonl(ntohl(conntrack->proto.tcp.handshake_seq)+1),
+						   conntrack->proto.tcp.new_handshake_ack,
+						   conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.tcp.port,
+						   conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.tcp.port,
+						   IPT_SD_ACK,
+						   conntrack
+						 ) < 0)
+		{
+			printk("ipt_SYNDIS: Sending last ACK packet to close relay connection failed.\n");
+			return -1;
+		}
+		
+		/* NB: This message terminates the three-way handshake of the moved connection, the
+		 *     conntrack can now be totally restored. */
+		ipt_sd_restore_the_connection(conntrack);
+	}
+	
+	/* If conntrack->ipt_sd_syndis_counter == NULL, the packet
+	 * is not tracked by the SYNDIs module (or the connection has
+	 * been assured).
+	 * The packet can be non-TCP or it can be a TCP packet tracked
+	 * by another iptable rule than SYNDIS. */
+	if (conntrack->ipt_sd_syndis_counter == NULL)
+		return NOTIFY_DONE;
+	
+	if (((events) & (1 << (IPCT_DESTROY))))
+	{
+		if (conntrack->ipt_sd_syndis_counter != NULL)
+		{
+			WRITE_LOCK(&syndis_conntrack_lock);
+			/* This connection was not assured before. It must be a dying SYN
+			 * packet from an attack. */
+			if (*(conntrack->ipt_sd_syndis_counter) != 0) 
+				(*(conntrack->ipt_sd_syndis_counter))--;
+			/* Fix me: 
+			 * A bug makes the counter goes sometimes under 0. (Maybe a message
+			 * that should not be taken into account here is taken into account?)
+			 * Problem: as the counter is unsigned, makes it takes the maximum value
+			 * thus the host concerned by this bug is never used again.
+			 * The line "if (*(conntrack->ipt_sd_syndis_counter) != 0)" is just
+			 * a dirty fix to the problem.
+			 */
+			/* Free the recorded packet; save memory! */
+			kfree(conntrack->proto.tcp.ipt_sd_original_syn_packet);
+			WRITE_UNLOCK(&syndis_conntrack_lock);
+		}
+		return NOTIFY_DONE;	
+	}
+	
+	if (((events) & (1 << (IPCT_SD_TCP_ASSURED))))
+	{
+		/* IF CONNECTION IS NOT ALREADY ON THE TARGET, 
+		 * MOVE THE CONNECTION TO IT:
+		 * THE "MOVING ESTABLISHED CONNECTIONS" PART
+		 */
+		if (conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip != ipt_sd_ip_target)
+		{
+			if (ipt_sd_close_old_connection(conntrack)!=0)
+				printk("ipt_SYNDIS: Error moving the connection from relay to target.");
+		}
+		WRITE_LOCK(&syndis_conntrack_lock);
+		(*(conntrack->ipt_sd_syndis_counter))--;
+		conntrack->ipt_sd_syndis_counter = NULL;
+		WRITE_UNLOCK(&syndis_conntrack_lock);
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_DONE;	
+}
+
+/* new ctnetlink's notifier registration facility to decrease counter. */
+static struct notifier_block ipt_syndis_notifier =
+{
+	ipt_syndis_conntrack_event,
+	NULL,
+	0
+};
+
+
+/*------------------- init / exit --------------------*/
+
+static int __init init(void)
+{
+	if (ip_conntrack_notify_register(&ipt_syndis_notifier))
+	{
+		printk("ipt_SYNDIS: cannot register notifier in init function.\n");
+		return 1;
+	}
+	
+	if (ipt_register_target(&ipt_syndis_reg))
+	{
+		printk("ipt_SYNDIS: cannot register target in init function.\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+static void __exit fini(void)
+{
+	ip_conntrack_notify_unregister(&ipt_syndis_notifier);	
+	ipt_unregister_target(&ipt_syndis_reg);
+}
+ 
+module_init(init);
+module_exit(fini);
+MODULE_AUTHOR("Emmanuel Guiton <emmanuel@netlab.hut.fi>");
+MODULE_DESCRIPTION("SYN-distributor functionnality support for ip_tables");
+MODULE_LICENSE("GPL");
diff -Nru linux-2.4.28/net/ipv4/netfilter/Makefile linux-2.4.28-modified/net/ipv4/netfilter/Makefile
--- linux-2.4.28/net/ipv4/netfilter/Makefile	2004-12-02 20:59:03.000000000 +0100
+++ linux-2.4.28-modified/net/ipv4/netfilter/Makefile	2004-12-02 20:55:46.000000000 +0100
@@ -110,6 +110,7 @@
 obj-$(CONFIG_IP_NF_TARGET_NETLINK) += ipt_NETLINK.o
 obj-$(CONFIG_IP_NF_TARGET_ULOG) += ipt_ULOG.o
 obj-$(CONFIG_IP_NF_TARGET_TCPMSS) += ipt_TCPMSS.o
+obj-$(CONFIG_IP_NF_TARGET_SYNDIS) += ipt_SYNDIS.o
 
 # generic ARP tables
 obj-$(CONFIG_IP_NF_ARPTABLES) += arp_tables.o

--------------040508010806060506060002--
