From: "manuel scheub" <manuprivat@gmx.de>
Subject: Re: AW: Add new target in mangle table
Date: Tue, 15 Apr 2008 14:47:22 +0200
Message-ID: <20080415124722.142920@gmx.net>
References: <20080414071710.C0E061802C4D8@sovereign.computergmbh.de>
 <alpine.LNX.1.10.0804141827370.9651@fbirervta.pbzchgretzou.qr>
 <20080414163449.293250@gmx.net>
 <alpine.LNX.1.10.0804141844520.9651@fbirervta.pbzchgretzou.qr>
 <20080415083543.20880@gmx.net>
 <alpine.LNX.1.10.0804151046120.9651@fbirervta.pbzchgretzou.qr>
 <20080415092052.107670@gmx.net>
 <alpine.LNX.1.10.0804151149070.9651@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="========GMX142921208263642964444"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59348 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754845AbYDOMr0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 08:47:26 -0400
In-Reply-To: <alpine.LNX.1.10.0804151149070.9651@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--========GMX142921208263642964444
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

-------- Original-Nachricht --------
> Datum: Tue, 15 Apr 2008 11:52:06 +0200 (CEST)
> Von: Jan Engelhardt <jengelh@computergmbh.de>
> An: manuel scheub <manuprivat@gmx.de>
> CC: netfilter-devel@vger.kernel.org
> Betreff: Re: AW: Add new target in mangle table

> 
> On Tuesday 2008-04-15 11:20, manuel scheub wrote:
> >> >
> >> >I modified the udhcpd from the busybox  - have a look in the attached
> >> >file.
> >> >To handle the different cases i wrote a shell script - also attached.
> >> 
> >> But if the client uses DHCP, why don't you hand out 10.0.x.x directly?
> >
> >If the client uses DHCP, i do hand out 10.0.x.x directly! The
> >modified dhcpd listens on all requests, it doesn't matter if it is
> >not a dhcp-request.
> 
> But there is only DHCPINFORM which might carry a non 10.0.x.x
> address.
> I think it's simpler if you just add 192.168.0.0/16 as an
> address to eth0.

There are some more modifications in the source code for the udhcp stuff in busybox. I think I didn't give you the correct information about the ip-plug'n'play with the dhcpd.c file. I've attached some more files, the main point is in the arpping.c. I've also attatched the file ippnpadd with the filter rules (there is also a file ippnpremove).
If I add 192.168.0.0/16, I didn't get the users with fix ip entries 10.120.0.1, 172.123.1.0,... maybe some business guys have these ip's.


-- 
Der GMX SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen! 
Ideal für Modem und ISDN: http://www.gmx.net/de/go/smartsurfer

--========GMX142921208263642964444
Content-Type: text/x-csrc; charset="iso-8859-15"; name="arpping.c"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="arpping.c"

/*
 * arpping.c
 *
 * Mostly stolen from: dhcpcd - DHCP client daemon
 * by Yoichi Hariguchi <yoichi@fore.com>
 */

#include <sys/time.h>
#include <time.h>
#include <sys/socket.h>
#include <netinet/if_ether.h>
#include <net/if_arp.h>
#include <netinet/in.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>

#include "dhcpd.h"
#include "arpping.h"
#include "common.h"
#include "options.h"

/* args:	yiaddr - what IP to ping
 *		ip - our ip
 *		mac - our arp address
 *		interface - interface to use
 * retn: 	1 addr free
 *		0 addr used
 *		-1 error 
 */  

/* FIXME: match response against chaddr */
int arpping(uint32_t yiaddr, uint32_t ip, uint8_t *mac, char *interface)
{

	int	timeout = 2;
	int 	optval = 1;
	int	s;			/* socket */
	int	rv = 1;			/* return value */
	struct sockaddr addr;		/* for interface name */
	struct arpMsg	arp;
	fd_set		fdset;
	struct timeval	tm;
	time_t		prevTime;


	if ((s = socket (PF_PACKET, SOCK_PACKET, htons(ETH_P_ARP))) == -1) {
#ifdef IN_BUSYBOX
		LOG(LOG_ERR, bb_msg_can_not_create_raw_socket);
#else
		LOG(LOG_ERR, "Could not open raw socket");
#endif
		return -1;
	}
	
	if (setsockopt(s, SOL_SOCKET, SO_BROADCAST, &optval, sizeof(optval)) == -1) {
		LOG(LOG_ERR, "Could not setsocketopt on raw socket");
		close(s);
		return -1;
	}

	/* send arp request */
	memset(&arp, 0, sizeof(arp));
	memcpy(arp.ethhdr.h_dest, MAC_BCAST_ADDR, 6);	/* MAC DA */
	memcpy(arp.ethhdr.h_source, mac, 6);		/* MAC SA */
	arp.ethhdr.h_proto = htons(ETH_P_ARP);		/* protocol type (Ethernet) */
	arp.htype = htons(ARPHRD_ETHER);		/* hardware type */
	arp.ptype = htons(ETH_P_IP);			/* protocol type (ARP message) */
	arp.hlen = 6;					/* hardware address length */
	arp.plen = 4;					/* protocol address length */
	arp.operation = htons(ARPOP_REQUEST);		/* ARP op code */
	memcpy(arp.sInaddr, &ip, sizeof(ip));		/* source IP address */
	memcpy(arp.sHaddr, mac, 6);			/* source hardware address */
	memcpy(arp.tInaddr, &yiaddr, sizeof(yiaddr));	/* target IP address */
	
	memset(&addr, 0, sizeof(addr));
	strcpy(addr.sa_data, interface);
	if (sendto(s, &arp, sizeof(arp), 0, &addr, sizeof(addr)) < 0)
		rv = 0;
	
	/* wait arp reply, and check it */
	tm.tv_usec = 0;
	time(&prevTime);
	while (timeout > 0) {
		FD_ZERO(&fdset);
		FD_SET(s, &fdset);
		tm.tv_sec = timeout;
		if (select(s + 1, &fdset, (fd_set *) NULL, (fd_set *) NULL, &tm) < 0) {
			DEBUG(LOG_ERR, "Error on ARPING request: %m");
			if (errno != EINTR) rv = 0;
		} else if (FD_ISSET(s, &fdset)) {
			if (recv(s, &arp, sizeof(arp), 0) < 0 ) rv = 0;
			if (arp.operation == htons(ARPOP_REPLY) && 
			    bcmp(arp.tHaddr, mac, 6) == 0 && 
			    *((uint32_t *) arp.sInaddr) == yiaddr) {
				DEBUG(LOG_INFO, "Valid arp reply receved for this address");
				rv = 0;
				break;
			}
		}
		timeout -= time(NULL) - prevTime;
		time(&prevTime);
	}
	close(s);
	DEBUG(LOG_INFO, "%salid arp replies for this address", rv ? "No v" : "V");	 
	return rv;
}

struct arpPacket {
        uint16_t htype;                         /* hardware type (must be ARPHRD_ETHER) */
        uint16_t ptype;                         /* protocol type (must be ETH_P_IP) */
        uint8_t  hlen;                          /* hardware address length (must be 6) */
        uint8_t  plen;                          /* protocol address length (must be 4) */
        uint16_t operation;                     /* ARP opcode */
        uint8_t  sHaddr[6];                     /* sender's hardware address */
        uint8_t  sInaddr[4];                    /* sender's IP address */
        uint8_t  tHaddr[6];                     /* target's hardware address */
        uint8_t  tInaddr[4];                    /* target's IP address */
        uint8_t  pad[18];                       /* pad for min. Ethernet payload (60 bytes) */
};

void handleArpRequest(unsigned char *mac, uint32_t ip)
{
	uint32_t freeaddr = 0;

	struct dhcpOfferedAddr *lease = find_lease_by_chaddr(mac);
	if (lease) {
		char buf[256];

		if (lease->ippnpaddr == ip) {
			if (!lease_expired(lease)) {
				lease->expires = time(0) + server_config.lease;
				DEBUG(LOG_INFO, "handleArpRequest: ip-addresses match");
				return;
			}
			DEBUG(LOG_INFO, "handleArpRequest: ip-addresses match but expired");
		}
		else if (!lease_expired(lease)) {
			if (ip == lease->yiaddr) {
				DEBUG(LOG_INFO, "handleArpRequest: assume dhcp lease");
				return;
			}
		}

		DEBUG(LOG_INFO, "handleArpRequest: ip-addresses differ %08X %08X", lease->ippnpaddr, ip);
		sprintf(buf, "ippnpremove %02X:%02X:%02X:%02X:%02X:%02X %d.%d.%d.%d %s", 
			lease->chaddr[0], lease->chaddr[1], lease->chaddr[2],
			lease->chaddr[3], lease->chaddr[4], lease->chaddr[5],
			(lease->yiaddr) & 0xff, (lease->yiaddr >> 8) & 0xff,
			(lease->yiaddr >> 16) & 0xff, (lease->yiaddr >> 24) & 0xff,
			lease->ifname);
		DEBUG(LOG_INFO, "Exec %s", buf);
		system(buf);
		freeaddr = lease->yiaddr;
		clear_lease(lease->chaddr, lease->yiaddr);
	}
	else
		freeaddr = find_address(0);

	if (!freeaddr)
		freeaddr = find_address(1);

	if (freeaddr) {
		struct option_set *o = find_option(server_config.options, DHCP_ROUTER);

		add_lease(mac, freeaddr, server_config.offer_time, ip, server_config.ifname[server_config.currentinterface]);
		if (o) {
			uint32_t gaddr;
			uint32_t extip1 = ip;
			unsigned char *pgaddr = (char *) &gaddr;
			unsigned char *pintip = (char *) &freeaddr;
			unsigned char *pextip = (char *) &ip;
			unsigned char *pextip1 = (char *) &extip1;
			char command[256];

			memcpy(&gaddr, &o->data[2], 4);

			if (server_config.offset != 1) {
				int leasenumber = (ntohl(freeaddr) - ntohl(server_config.start)) / server_config.offset;

				gaddr = ntohl(gaddr);
				gaddr += (server_config.offset * leasenumber);
				gaddr = htonl(gaddr);
			}
			if (pextip1[3] == 1)
				pextip1[3]++;
			else
				pextip1[3]--;

			sprintf(command, "ippnpadd %02X:%02X:%02X:%02X:%02X:%02X %d.%d.%d.%d %d.%d.%d.%d %d.%d.%d.%d %d.%d.%d.%d %s",
				mac[0], mac[1], mac[2], mac[3], mac[4], mac[5],
				pgaddr[0], pgaddr[1], pgaddr[2], pgaddr[3],
				pintip[0], pintip[1], pintip[2], pintip[3],
				pextip[0], pextip[1], pextip[2], pextip[3],
				pextip1[0], pextip1[1], pextip1[2], pextip1[3],
				server_config.ifname[server_config.currentinterface]);
			DEBUG(LOG_INFO, "Exec %s", command);
			system(command);
		}
	}
}


int handleArpPacket(uint8_t *a)
{
	struct arpPacket *arp = (struct arpPacket *) a;
	DEBUG(LOG_INFO, "%d %d %d %d %d\n", arp->htype, arp->ptype, arp->hlen, arp->plen, ntohs(arp->operation));
	DEBUG(LOG_INFO, "%02x:%02x:%02x:%02x:%02x:%02x %d.%d.%d.%d %02x:%02x:%02x:%02x:%02x:%02x %d.%d.%d.%d\n",
		arp->sHaddr[0], arp->sHaddr[1], arp->sHaddr[2], arp->sHaddr[3], arp->sHaddr[4], arp->sHaddr[5],
		arp->sInaddr[0], arp->sInaddr[1], arp->sInaddr[2], arp->sInaddr[3],
		arp->tHaddr[0], arp->tHaddr[1], arp->tHaddr[2], arp->tHaddr[3], arp->tHaddr[4], arp->tHaddr[5],
		arp->tInaddr[0], arp->tInaddr[1], arp->tInaddr[2], arp->tInaddr[3]
	);
	if (ntohs(arp->operation) == 1 && memcmp(server_config.arp[server_config.currentinterface], arp->sHaddr, 6) != 0) {
                uint32_t ip;
		unsigned char chaddr[16];

		memset(chaddr, 0, 16);
		memcpy(chaddr, arp->sHaddr, 6);
		memcpy(&ip, arp->sInaddr, 4);

                handleArpRequest(chaddr, ip);
	}
	return 0;
}

--========GMX142921208263642964444
Content-Type: text/x-csrc; charset="iso-8859-15"; name="files.c"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="files.c"

/* 
 * files.c -- DHCP server file manipulation *
 * Rewrite by Russ Dill <Russ.Dill@asu.edu> July 2001
 */
 
#include <sys/socket.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <ctype.h>
#include <netdb.h>

#include "dhcpd.h"
#include "files.h"
#include "options.h"
#include "common.h"

/* 
 * Domain names may have 254 chars, and string options can be 254
 * chars long. However, 80 bytes will be enough for most, and won't
 * hog up memory. If you have a special application, change it
 */
#define READ_CONFIG_BUF_SIZE 16384

/* on these functions, make sure you datatype matches */
static int read_ip(const char *line, void *arg)
{
	struct in_addr *addr = arg;
	struct hostent *host;
	int retval = 1;

	if (!inet_aton(line, addr)) {
		if ((host = gethostbyname(line))) 
			addr->s_addr = *((unsigned long *) host->h_addr_list[0]);
		else retval = 0;
	}
	return retval;
}


static int read_str(const char *line, void *arg)
{
	char **dest = arg;
	
	if (*dest) free(*dest);
	*dest = strdup(line);
	
	return 1;
}


static int read_u32(const char *line, void *arg)
{
	uint32_t *dest = arg;
	char *endptr;
	*dest = strtoul(line, &endptr, 0);
	return endptr[0] == '\0';
}


static int read_yn(const char *line, void *arg)
{
	char *dest = arg;
	int retval = 1;

	if (!strcasecmp("yes", line))
		*dest = 1;
	else if (!strcasecmp("no", line))
		*dest = 0;
	else retval = 0;
	
	return retval;
}


/* read a dhcp option and add it to opt_list */
static int read_opt(const char *const_line, void *arg)
{
	struct option_set **opt_list = arg;
	char *opt, *val, *endptr;
	struct dhcp_option *option;
	int retval = 0, length;
	char buffer[8];
	char *line;
	uint16_t *result_u16 = (uint16_t *) buffer;
	uint32_t *result_u32 = (uint32_t *) buffer;

	/* Cheat, the only const line we'll actually get is "" */
	line = (char *) const_line;
	if (!(opt = strtok(line, " \t="))) return 0;
	
	for (option = dhcp_options; option->code; option++)
		if (!strcasecmp(option->name, opt))
			break;
	
	if (!option->code) return 0;

	do {
		if (!(val = strtok(NULL, ", \t"))) break;
		length = option_lengths[option->flags & TYPE_MASK];
		retval = 0;
		opt = buffer; /* new meaning for variable opt */
		switch (option->flags & TYPE_MASK) {
		case OPTION_IP:
			retval = read_ip(val, buffer);
			break;
		case OPTION_IP_PAIR:
			retval = read_ip(val, buffer);
			if (!(val = strtok(NULL, ", \t/-"))) retval = 0;
			if (retval) retval = read_ip(val, buffer + 4);
			break;
		case OPTION_STRING:
			length = strlen(val);
			if (length > 0) {
				if (length > 254) length = 254;
				opt = val;
				retval = 1;
			}
			break;
		case OPTION_BOOLEAN:
			retval = read_yn(val, buffer);
			break;
		case OPTION_U8:
			buffer[0] = strtoul(val, &endptr, 0);
			retval = (endptr[0] == '\0');
			break;
		case OPTION_U16:
			*result_u16 = htons(strtoul(val, &endptr, 0));
			retval = (endptr[0] == '\0');
			break;
		case OPTION_S16:
			*result_u16 = htons(strtol(val, &endptr, 0));
			retval = (endptr[0] == '\0');
			break;
		case OPTION_U32:
			*result_u32 = htonl(strtoul(val, &endptr, 0));	
			retval = (endptr[0] == '\0');
			break;
		case OPTION_S32:
			*result_u32 = htonl(strtol(val, &endptr, 0));	
			retval = (endptr[0] == '\0');
			break;
		default:
			break;
		}
		if (retval) 
			attach_option(opt_list, option, opt, length);
	} while (retval && option->flags & OPTION_LIST);
	return retval;
}


static const struct config_keyword keywords[] = {
	/* keyword	handler   variable address		default */
	{"start",	read_ip,  &(server_config.start),	"192.168.0.20"},
	{"end",		read_ip,  &(server_config.end),		"192.168.0.254"},
	{"interface",	read_str, &(server_config.interfaces),	"eth0"},
	{"option",	read_opt, &(server_config.options),	""},
	{"opt",		read_opt, &(server_config.options),	""},
	{"max_leases",	read_u32, &(server_config.max_leases),	"254"},
	{"offset",	read_u32, &(server_config.offset),	"1"},
	{"send_mult",	read_u32, &(server_config.send_mult),	"1"},
	{"keep_dns",    read_u32, &(server_config.keep_dns),    "0"},
	{"ippnp",	read_u32, &(server_config.ippnp),	"0"},
	{"remaining",	read_yn,  &(server_config.remaining),	"yes"},
	{"auto_time",	read_u32, &(server_config.auto_time),	"7200"},
	{"decline_time",read_u32, &(server_config.decline_time),"3600"},
	{"conflict_time",read_u32,&(server_config.conflict_time),"3600"},
	{"offer_time",	read_u32, &(server_config.offer_time),	"60"},
	{"min_lease",	read_u32, &(server_config.min_lease),	"60"},
	{"lease_file",	read_str, &(server_config.lease_file),	LEASES_FILE},
	{"pidfile",	read_str, &(server_config.pidfile),	"/var/run/udhcpd.pid"},
	{"notify_file", read_str, &(server_config.notify_file),	""},
	{"siaddr",	read_ip,  &(server_config.siaddr),	"0.0.0.0"},
	{"sname",	read_str, &(server_config.sname),	""},
	{"boot_file",	read_str, &(server_config.boot_file),	""},
	/*ADDME: static lease */
	{"",		NULL, 	  NULL,				""}
};


int read_config(const char *file)
{
	FILE *in;
	char buffer[READ_CONFIG_BUF_SIZE], *token, *line;
#ifdef UDHCP_DEBUG
	char orig[READ_CONFIG_BUF_SIZE];
#endif
	int i, lm = 0;

	for (i = 0; keywords[i].keyword[0]; i++)
		if (keywords[i].def[0])
			keywords[i].handler(keywords[i].def, keywords[i].var);

	if (!(in = fopen(file, "r"))) {
		LOG(LOG_ERR, "unable to open config file: %s", file);
		return 0;
	}
	
	while (fgets(buffer, READ_CONFIG_BUF_SIZE, in)) {
		lm++;
		if (strchr(buffer, '\n')) *(strchr(buffer, '\n')) = '\0';
#ifdef UDHCP_DEBUG
		strcpy(orig, buffer);
#endif
		if (strchr(buffer, '#')) *(strchr(buffer, '#')) = '\0';

		if (!(token = strtok(buffer, " \t"))) continue;
		if (!(line = strtok(NULL, ""))) continue;		
		
		/* eat leading whitespace */
		line = line + strspn(line, " \t=");
		/* eat trailing whitespace */
		for (i = strlen(line); i > 0 && isspace(line[i - 1]); i--);
		line[i] = '\0';
		
		for (i = 0; keywords[i].keyword[0]; i++)
			if (!strcasecmp(token, keywords[i].keyword))
				if (!keywords[i].handler(line, keywords[i].var)) {
					LOG(LOG_ERR, "Failure parsing line %d of %s", lm, file);
					DEBUG(LOG_ERR, "unable to parse '%s'", orig);
					/* reset back to the default value */
					keywords[i].handler(keywords[i].def, keywords[i].var);
				}
	}
	fclose(in);
	return 1;
}


void write_leases(void)
{
	FILE *fp;
	unsigned int i;
	char buf[255];
	time_t curr = time(0);
	unsigned long tmp_time;
	
	if (!(fp = fopen(server_config.lease_file, "w"))) {
		LOG(LOG_ERR, "Unable to open %s for writing", server_config.lease_file);
		return;
	}
	
	for (i = 0; i < server_config.max_leases; i++) {
		if (leases[i].yiaddr != 0) {

			/* screw with the time in the struct, for easier writing */
			tmp_time = leases[i].expires;

			if (server_config.remaining) {
				if (lease_expired(&(leases[i]))) {
					if (leases[i].expires + server_config.auto_time + 20 >= curr) {
						if (leases[i].ippnpaddr) {
							sprintf(buf, "ippnpremove %02X:%02X:%02X:%02X:%02X:%02X %d.%d.%d.%d %s", 
								leases[i].chaddr[0], leases[i].chaddr[1], leases[i].chaddr[2],
								leases[i].chaddr[3], leases[i].chaddr[4], leases[i].chaddr[5],
								leases[i].yiaddr & 0xff, (leases[i].yiaddr >> 8) & 0xff,
								(leases[i].yiaddr >> 16) & 0xff, (leases[i].yiaddr >> 24) & 0xff,
								leases[i].ifname);
							DEBUG(LOG_INFO, "Exec %s", buf);
							system(buf);
						} else {
							sprintf(buf, "dhcpd.sh release %02X:%02X:%02X:%02X:%02X:%02X %d.%d.%d.%d %s",
								leases[i].chaddr[0], leases[i].chaddr[1], leases[i].chaddr[2],
								leases[i].chaddr[3], leases[i].chaddr[4], leases[i].chaddr[5],
								leases[i].yiaddr & 0xff, (leases[i].yiaddr >> 8) & 0xff,
								(leases[i].yiaddr >> 16) & 0xff, (leases[i].yiaddr >> 24) & 0xff, 
								leases[i].ifname );
							DEBUG(LOG_INFO, "Exec %s", buf);
							system(buf);
						}
					}
					leases[i].expires = 0;
				}
				else leases[i].expires -= curr;
			} /* else stick with the time we got */
			leases[i].expires = htonl(leases[i].expires);
			fwrite(&leases[i], sizeof(struct dhcpOfferedAddr), 1, fp);

			/* Then restore it when done. */
			leases[i].expires = tmp_time;
		}
	}
	fclose(fp);
	
	if (server_config.notify_file) {
		sprintf(buf, "%s %s", server_config.notify_file, server_config.lease_file);
		system(buf);
	}
}


void read_leases(const char *file)
{
	FILE *fp;
	unsigned int i = 0;
	struct dhcpOfferedAddr lease;
	struct stat buf;
	
	if (!(fp = fopen(file, "r"))) {
		LOG(LOG_ERR, "Unable to open %s for reading", file);
		return;
	}

	if (fstat(fileno(fp), &buf) != 0) {
		LOG(LOG_ERR, "Unable to get filesize for %s", file);
		return;
	}

	if (buf.st_size % (sizeof lease) != 0) {
		LOG(LOG_ERR, "Probably unknown file structure in %s", file);
		return;
	}
	
	while (i < server_config.max_leases && (fread(&lease, sizeof lease, 1, fp) == 1)) {
		/* ADDME: is it a static lease */
		if (lease.yiaddr >= server_config.start && lease.yiaddr <= server_config.end) {
			lease.expires = ntohl(lease.expires);
			if (!server_config.remaining) lease.expires -= time(0);
			if (!(add_lease(lease.chaddr, lease.yiaddr, lease.expires, lease.ippnpaddr, lease.ifname))) {
				LOG(LOG_WARNING, "Too many leases while loading %s\n", file);
				break;
			}				
			i++;
		}
	}
	DEBUG(LOG_INFO, "Read %d leases", i);
	fclose(fp);
}

--========GMX142921208263642964444
Content-Type: text/x-csrc; charset="iso-8859-15"; name="leases.c"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="leases.c"

/*
 * leases.c -- tools to manage DHCP leases
 * Russ Dill <Russ.Dill@asu.edu> July 2001
 */

#include <time.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include "dhcpd.h"
#include "files.h"
#include "options.h"
#include "leases.h"
#include "arpping.h"
#include "common.h"


uint8_t blank_chaddr[] = {[0 ... 15] = 0};

/* clear every lease out that chaddr OR yiaddr matches and is nonzero */
void clear_lease(uint8_t *chaddr, uint32_t yiaddr)
{
	unsigned int i, j;

	for (j = 0; j < 16 && !chaddr[j]; j++);

	for (i = 0; i < server_config.max_leases; i++)
		if ((j != 16 && !memcmp(leases[i].chaddr, chaddr, 16)) ||
		    (yiaddr && leases[i].yiaddr == yiaddr)) {
			memset(&(leases[i]), 0, sizeof(struct dhcpOfferedAddr));
		}
}


/* add a lease into the table, clearing out any old ones */
struct dhcpOfferedAddr *add_lease(uint8_t *chaddr, uint32_t yiaddr, unsigned long lease, uint32_t ippnpaddr, char *ifname)
{
	struct dhcpOfferedAddr *oldest;
	
	/* clean out any old ones */
	clear_lease(chaddr, yiaddr);
		
	oldest = oldest_expired_lease();
	
	if (oldest) {
		memcpy(oldest->chaddr, chaddr, 16);
		oldest->yiaddr = yiaddr;
		oldest->expires = time(0) + lease;
		oldest->ippnpaddr = ippnpaddr;
		strcpy(oldest->ifname, ifname);
	}
	
	return oldest;
}


/* true if a lease has expired */
int lease_expired(struct dhcpOfferedAddr *lease)
{
	return (lease->expires < (unsigned long) time(0));
}	


/* Find the oldest expired lease, NULL if there are no expired leases */
struct dhcpOfferedAddr *oldest_expired_lease(void)
{
	struct dhcpOfferedAddr *oldest = NULL;
	unsigned long oldest_lease = time(0);
	unsigned int i;

	
	for (i = 0; i < server_config.max_leases; i++)
		if (oldest_lease > leases[i].expires) {
			oldest_lease = leases[i].expires;
			oldest = &(leases[i]);
		}
	return oldest;
}


/* Find the first lease that matches chaddr, NULL if no match */
struct dhcpOfferedAddr *find_lease_by_chaddr(uint8_t *chaddr)
{
	unsigned int i;

	for (i = 0; i < server_config.max_leases; i++)
		if (!memcmp(leases[i].chaddr, chaddr, 16)) return &(leases[i]);
	
	return NULL;
}


/* Find the first lease that matches yiaddr, NULL is no match */
struct dhcpOfferedAddr *find_lease_by_yiaddr(uint32_t yiaddr)
{
	unsigned int i;

	for (i = 0; i < server_config.max_leases; i++)
		if (leases[i].yiaddr == yiaddr) return &(leases[i]);
	
	return NULL;
}


/* check is an IP is taken, if it is, add it to the lease table */
static int check_ip(uint32_t addr)
{
	struct in_addr temp;

	if (arpping(addr, server_config.server[server_config.currentinterface],
			 server_config.arp[server_config.currentinterface], server_config.ifname[server_config.currentinterface]) == 0) {
		temp.s_addr = addr;
		LOG(LOG_INFO, "%s belongs to someone, reserving it for %ld seconds",
			inet_ntoa(temp), server_config.conflict_time);
		add_lease(blank_chaddr, addr, server_config.conflict_time, 0, "");
		return 1;
	} else return 0;
}


/* find an assignable address, it check_expired is true, we check all the expired leases as well.
 * Maybe this should try expired leases by age... */
uint32_t find_address(int check_expired)
{
	uint32_t addr;
	uint32_t ret = 0;
	struct dhcpOfferedAddr *lease = NULL;

	addr = ntohl(server_config.start); /* addr is in host order here */
	for (;addr <= ntohl(server_config.end); addr += server_config.offset) {

		/* ie, 192.168.55.0 */
		if (!(addr & 0xFF)) continue;

		/* ie, 192.168.55.255 */
		if ((addr & 0xFF) == 0xFF) continue;

		/* lease is not taken */
		ret = htonl(addr);
		if ((!(find_lease_by_yiaddr(ret))) &&
		     /* and it isn't on the network */
			!check_ip(ret)) {
			return ret;
		}
	}
	if (!check_expired)
		return 0;

	while ((lease = oldest_expired_lease()) != 0) {

		/* ie, 192.168.55.0 */
		/* if (!(addr & 0xFF)) continue */;

		/* ie, 192.168.55.255 */
		/* if ((addr & 0xFF) == 0xFF) continue */

		/* and it isn't on the network */
		if (!check_ip(lease->yiaddr)) {
			if (lease->expires + server_config.auto_time + 20 >= time(0)) {
				char buf[255];

				sprintf(buf, "dhcpd.sh release %02X:%02X:%02X:%02X:%02X:%02X %d.%d.%d.%d %s",
					lease->chaddr[0], lease->chaddr[1], lease->chaddr[2],
					lease->chaddr[3], lease->chaddr[4], lease->chaddr[5],
					lease->yiaddr & 0xff, (lease->yiaddr >> 8) & 0xff,
					(lease->yiaddr >> 16) & 0xff, (lease->yiaddr >> 24) & 0xff,
					lease->ifname);
				system(buf);
				if (lease->ippnpaddr) {
					sprintf(buf, "ippnpremove %02X:%02X:%02X:%02X:%02X:%02X %d.%d.%d.%d %s",
						lease->chaddr[0], lease->chaddr[1], lease->chaddr[2],
						lease->chaddr[3], lease->chaddr[4], lease->chaddr[5],
						(lease->yiaddr) & 0xff, (lease->yiaddr >> 8) & 0xff,
						(lease->yiaddr >> 16) & 0xff, (lease->yiaddr >> 24) & 0xff,
						lease->ifname);
					DEBUG(LOG_INFO, "Exec %s", buf);
					system(buf);
				}
			}
			return lease->yiaddr;
		}
	}
	return 0;
}

--========GMX142921208263642964444
Content-Type: text/x-csrc; charset="iso-8859-15"; name="options.c"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="options.c"

/* 
 * options.c -- DHCP server option packet tools 
 * Rewrite by Russ Dill <Russ.Dill@asu.edu> July 2001
 */
 
#include <stdlib.h>
#include <string.h>

#include "dhcpd.h"
#include "files.h"
#include "options.h"
#include "common.h"


/* supported options are easily added here */
struct dhcp_option dhcp_options[] = {
	/* name[10]	flags					code */
	{"subnet",	OPTION_IP | OPTION_REQ,			0x01},
	{"timezone",	OPTION_S32,				0x02},
	{"router",	OPTION_IP | OPTION_LIST | OPTION_REQ,	0x03},
	{"timesvr",	OPTION_IP | OPTION_LIST,		0x04},
	{"namesvr",	OPTION_IP | OPTION_LIST,		0x05},
	{"dns",		OPTION_IP | OPTION_LIST | OPTION_REQ,	0x06},
	{"logsvr",	OPTION_IP | OPTION_LIST,		0x07},
	{"cookiesvr",	OPTION_IP | OPTION_LIST,		0x08},
	{"lprsvr",	OPTION_IP | OPTION_LIST,		0x09},
	{"hostname",	OPTION_STRING | OPTION_REQ,		0x0c},
	{"bootsize",	OPTION_U16,				0x0d},
	{"domain",	OPTION_STRING | OPTION_REQ,		0x0f},
	{"swapsvr",	OPTION_IP,				0x10},
	{"rootpath",	OPTION_STRING,				0x11},
	{"ipttl",	OPTION_U8,				0x17},
	{"mtu",		OPTION_U16,				0x1a},
	{"broadcast",	OPTION_IP | OPTION_REQ,			0x1c},
	{"ntpsrv",	OPTION_IP | OPTION_LIST,		0x2a},
	{"wins",	OPTION_IP | OPTION_LIST,		0x2c},
	{"requestip",	OPTION_IP,				0x32},
	{"lease",	OPTION_U32,				0x33},
	{"dhcptype",	OPTION_U8,				0x35},
	{"serverid",	OPTION_IP,				0x36},
	{"message",	OPTION_STRING,				0x38},
	{"tftp",	OPTION_STRING,				0x42},
	{"bootfile",	OPTION_STRING,				0x43},
	{"",		0x00,				0x00}
};

/* Lengths of the different option types */
int option_lengths[] = {
	[OPTION_IP] =		4,
	[OPTION_IP_PAIR] =	8,
	[OPTION_BOOLEAN] =	1,
	[OPTION_STRING] =	1,
	[OPTION_U8] =		1,
	[OPTION_U16] =		2,
	[OPTION_S16] =		2,
	[OPTION_U32] =		4,
	[OPTION_S32] =		4
};


/* get an option with bounds checking (warning, not aligned). */
uint8_t *get_option(struct dhcpMessage *packet, int code)
{
	int i, length;
	uint8_t *optionptr;
	int over = 0, done = 0, curr = OPTION_FIELD;
	
	optionptr = packet->options;
	i = 0;
	length = 308;
	while (!done) {
		if (i >= length) {
			LOG(LOG_WARNING, "bogus packet, option fields too long.");
			return NULL;
		}
		if (optionptr[i + OPT_CODE] == code) {
			if (i + 1 + optionptr[i + OPT_LEN] >= length) {
				LOG(LOG_WARNING, "bogus packet, option fields too long.");
				return NULL;
			}
			return optionptr + i + 2;
		}			
		switch (optionptr[i + OPT_CODE]) {
		case DHCP_PADDING:
			i++;
			break;
		case DHCP_OPTION_OVER:
			if (i + 1 + optionptr[i + OPT_LEN] >= length) {
				LOG(LOG_WARNING, "bogus packet, option fields too long.");
				return NULL;
			}
			over = optionptr[i + 3];
			i += optionptr[OPT_LEN] + 2;
			break;
		case DHCP_END:
			if (curr == OPTION_FIELD && over & FILE_FIELD) {
				optionptr = packet->file;
				i = 0;
				length = 128;
				curr = FILE_FIELD;
			} else if (curr == FILE_FIELD && over & SNAME_FIELD) {
				optionptr = packet->sname;
				i = 0;
				length = 64;
				curr = SNAME_FIELD;
			} else done = 1;
			break;
		default:
			i += optionptr[OPT_LEN + i] + 2;
		}
	}
	return NULL;
}


/* return the position of the 'end' option (no bounds checking) */
int end_option(uint8_t *optionptr) 
{
	int i = 0;
	
	while (optionptr[i] != DHCP_END) {
		if (optionptr[i] == DHCP_PADDING) i++;
		else i += optionptr[i + OPT_LEN] + 2;
	}
	return i;
}


/* add an option string to the options (an option string contains an option code,
 * length, then data) */
int add_option_string(uint8_t *optionptr, uint8_t *string, uint32_t leasenumber)
{
	int end = end_option(optionptr);
	uint8_t buffer[255];
	
	/* end position + string length + option code/length + end option */
	if (end + string[OPT_LEN] + 2 + 1 >= 308) {
		LOG(LOG_ERR, "Option 0x%02x did not fit into the packet!", string[OPT_CODE]);
		return 0;
	}
	DEBUG(LOG_INFO, "adding option 0x%02x", string[OPT_CODE]);

	memcpy(buffer, string, string[OPT_LEN] + 2);

	if (buffer[OPT_CODE] == 0x03) {
		if (server_config.offset != 1) {
			uint32_t addr;

			memcpy(&addr, &buffer[2], 4);
			addr = ntohl(addr);
			addr += (server_config.offset * leasenumber);
			addr = htonl(addr);
			memcpy(&buffer[2], &addr, 4);
		}	
	}

	if (buffer[OPT_CODE] == 0x05 || buffer[OPT_CODE] == 0x06) {
		if (server_config.offset != 1 && !server_config.keep_dns) {
			uint32_t addr;

			memcpy(&addr, &buffer[2], 4);
			addr = ntohl(addr);
			addr += (server_config.offset * leasenumber);
			addr = htonl(addr);
			memcpy(&buffer[2], &addr, 4);
		}	
	}

	memcpy(optionptr + end, buffer, buffer[OPT_LEN] + 2);
	optionptr[end + string[OPT_LEN] + 2] = DHCP_END;
	return string[OPT_LEN] + 2;
}


/* add a one to four byte option to a packet */
int add_simple_option(uint8_t *optionptr, uint8_t code, uint32_t data)
{
	char length = 0;
	int i;
	uint8_t option[2 + 4];
	uint8_t *u8;
	uint16_t *u16;
	uint32_t *u32;
	uint32_t aligned;
	u8 = (uint8_t *) &aligned;
	u16 = (uint16_t *) &aligned;
	u32 = &aligned;

	for (i = 0; dhcp_options[i].code; i++)
		if (dhcp_options[i].code == code) {
			length = option_lengths[dhcp_options[i].flags & TYPE_MASK];
		}
		
	if (!length) {
		DEBUG(LOG_ERR, "Could not add option 0x%02x", code);
		return 0;
	}
	
	option[OPT_CODE] = code;
	option[OPT_LEN] = length;

	switch (length) {
		case 1: *u8 =  data; break;
		case 2: *u16 = data; break;
		case 4: *u32 = data; break;
	}
	memcpy(option + 2, &aligned, length);
	return add_option_string(optionptr, option, 1);
}


/* find option 'code' in opt_list */
struct option_set *find_option(struct option_set *opt_list, char code)
{
	while (opt_list && opt_list->data[OPT_CODE] < code)
		opt_list = opt_list->next;

	if (opt_list && opt_list->data[OPT_CODE] == code) return opt_list;
	else return NULL;
}


/* add an option to the opt_list */
void attach_option(struct option_set **opt_list, struct dhcp_option *option, char *buffer, int length)
{
	struct option_set *existing, *new, **curr;

	/* add it to an existing option */
	if ((existing = find_option(*opt_list, option->code))) {
		DEBUG(LOG_INFO, "Attaching option %s to existing member of list", option->name);
		if (option->flags & OPTION_LIST) {
			if (existing->data[OPT_LEN] + length <= 255) {
				existing->data = realloc(existing->data, 
						existing->data[OPT_LEN] + length + 2);
				memcpy(existing->data + existing->data[OPT_LEN] + 2, buffer, length);
				existing->data[OPT_LEN] += length;
			} /* else, ignore the data, we could put this in a second option in the future */
		} /* else, ignore the new data */
	} else {
		DEBUG(LOG_INFO, "Attaching option %s to list", option->name);
		
		/* make a new option */
		new = xmalloc(sizeof(struct option_set));
		new->data = xmalloc(length + 2);
		new->data[OPT_CODE] = option->code;
		new->data[OPT_LEN] = length;
		memcpy(new->data + 2, buffer, length);
		
		curr = opt_list;
		while (*curr && (*curr)->data[OPT_CODE] < option->code)
			curr = &(*curr)->next;
			
		new->next = *curr;
		*curr = new;		
	}
}

--========GMX142921208263642964444
Content-Type: text/x-csrc; charset="iso-8859-15"; name="packet.c"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="packet.c"

#include <unistd.h>
#include <string.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <features.h>
#if __GLIBC__ >=2 && __GLIBC_MINOR >= 1
#include <netpacket/packet.h>
#include <net/ethernet.h>
#else
#include <asm/types.h>
#include <linux/if_packet.h>
#include <linux/if_ether.h>
#endif
#include <errno.h>

#include "packet.h"
#include "dhcpd.h"
#include "options.h"
#include "common.h"


void init_header(struct dhcpMessage *packet, char type)
{
	memset(packet, 0, sizeof(struct dhcpMessage));
	switch (type) {
	case DHCPDISCOVER:
	case DHCPREQUEST:
	case DHCPRELEASE:
	case DHCPINFORM:
		packet->op = BOOTREQUEST;
		break;
	case DHCPOFFER:
	case DHCPACK:
	case DHCPNAK:
		packet->op = BOOTREPLY;
	}
	packet->htype = ETH_10MB;
	packet->hlen = ETH_10MB_LEN;
	packet->cookie = htonl(DHCP_MAGIC);
	packet->options[0] = DHCP_END;
	add_simple_option(packet->options, DHCP_MESSAGE_TYPE, type);
}


/* read a packet from socket fd, return -1 on read error, -2 on packet error */
int get_packet(struct dhcpMessage *packet, int fd)
{
	int bytes;
	int i;
	const char broken_vendors[][8] = {
		"MSFT 98",
		""
	};
	char unsigned *vendor;

	memset(packet, 0, sizeof(struct dhcpMessage));
	bytes = read(fd, packet, sizeof(struct dhcpMessage));
	if (bytes < 0) {
		DEBUG(LOG_INFO, "couldn't read on listening socket, ignoring");
		return -1;
	}

	if (ntohl(packet->cookie) != DHCP_MAGIC) {
		LOG(LOG_ERR, "received bogus message, ignoring");
		return -2;
	}
	DEBUG(LOG_INFO, "Received a packet");
	
	if (packet->op == BOOTREQUEST && (vendor = get_option(packet, DHCP_VENDOR))) {
		for (i = 0; broken_vendors[i][0]; i++) {
			if (vendor[OPT_LEN - 2] == (uint8_t) strlen(broken_vendors[i]) &&
			    !strncmp(vendor, broken_vendors[i], vendor[OPT_LEN - 2])) {
			    	DEBUG(LOG_INFO, "broken client (%s), forcing broadcast",
			    		broken_vendors[i]);
			    	packet->flags |= htons(BROADCAST_FLAG);
			}
		}
	}
			    	

	return bytes;
}


uint16_t checksum(void *addr, int count)
{
	/* Compute Internet Checksum for "count" bytes
	 *         beginning at location "addr".
	 */
	register int32_t sum = 0;
	uint16_t *source = (uint16_t *) addr;

	while (count > 1)  {
		/*  This is the inner loop */
		sum += *source++;
		count -= 2;
	}

	/*  Add left-over byte, if any */
	if (count > 0) {
		/* Make sure that the left-over byte is added correctly both
		 * with little and big endian hosts */
		uint16_t tmp = 0;
		*(uint8_t *) (&tmp) = * (uint8_t *) source;
		sum += tmp;
	}
	/*  Fold 32-bit sum to 16 bits */
	while (sum >> 16)
		sum = (sum & 0xffff) + (sum >> 16);

	return ~sum;
}


/* Constuct a ip/udp header for a packet, and specify the source and dest hardware address */
int raw_packet(struct dhcpMessage *payload, uint32_t source_ip, int source_port,
		   uint32_t dest_ip, int dest_port, uint8_t *dest_arp, int ifindex)
{
	int fd;
	int result = -1;
	struct sockaddr_ll dest;
	struct udp_dhcp_packet packet;
	int i;

	if ((fd = socket(PF_PACKET, SOCK_DGRAM, htons(ETH_P_IP))) < 0) {
		DEBUG(LOG_ERR, "socket call failed: %m");
		return -1;
	}
	
	memset(&dest, 0, sizeof(dest));
	memset(&packet, 0, sizeof(packet));
	
	dest.sll_family = AF_PACKET;
	dest.sll_protocol = htons(ETH_P_IP);
	dest.sll_ifindex = ifindex;
	dest.sll_halen = 6;
	memcpy(dest.sll_addr, dest_arp, 6);
	if (bind(fd, (struct sockaddr *)&dest, sizeof(struct sockaddr_ll)) < 0) {
		DEBUG(LOG_ERR, "bind call failed: %m");
		close(fd);
		return -1;
	}

	packet.ip.protocol = IPPROTO_UDP;
	packet.ip.saddr = source_ip;
	packet.ip.daddr = dest_ip;
	packet.udp.source = htons(source_port);
	packet.udp.dest = htons(dest_port);
	packet.udp.len = htons(sizeof(packet.udp) + sizeof(struct dhcpMessage)); /* cheat on the psuedo-header */
	packet.ip.tot_len = packet.udp.len;
	memcpy(&(packet.data), payload, sizeof(struct dhcpMessage));
	packet.udp.check = checksum(&packet, sizeof(struct udp_dhcp_packet));
	
	packet.ip.tot_len = htons(sizeof(struct udp_dhcp_packet));
	packet.ip.ihl = sizeof(packet.ip) >> 2;
	packet.ip.version = IPVERSION;
	packet.ip.ttl = IPDEFTTL;
	packet.ip.check = checksum(&(packet.ip), sizeof(packet.ip));

	LOG(LOG_INFO, "raw_packet: send %d times", server_config.send_mult);
	for (i = 0; i < server_config.send_mult; i++) {
		result = sendto(fd, &packet, sizeof(struct udp_dhcp_packet), 0, (struct sockaddr *) &dest, sizeof(dest));
		if (result <= 0) {
			DEBUG(LOG_ERR, "write on socket failed: %m");
		}
	}
	close(fd);
	return result;
}


/* Let the kernel do all the work for packet generation */
int kernel_packet(struct dhcpMessage *payload, uint32_t source_ip, int source_port,
		   uint32_t dest_ip, int dest_port)
{
	int n = 1;
	int fd, result;
	struct sockaddr_in client;
	
	if ((fd = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0)
		return -1;
	
	if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, (char *) &n, sizeof(n)) == -1)
		return -1;

	memset(&client, 0, sizeof(client));
	client.sin_family = AF_INET;
	client.sin_port = htons(source_port);
	client.sin_addr.s_addr = source_ip;

	if (bind(fd, (struct sockaddr *)&client, sizeof(struct sockaddr)) == -1)
		return -1;

	memset(&client, 0, sizeof(client));
	client.sin_family = AF_INET;
	client.sin_port = htons(dest_port);
	client.sin_addr.s_addr = dest_ip; 

	if (connect(fd, (struct sockaddr *)&client, sizeof(struct sockaddr)) == -1)
		return -1;

	result = write(fd, payload, sizeof(struct dhcpMessage));
	close(fd);
	return result;
}	

--========GMX142921208263642964444
Content-Type: text/x-csrc; charset="iso-8859-15"; name="socket.c"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="socket.c"

/*
 * socket.c -- DHCP server client/server socket creation
 *
 * udhcp client/server
 * Copyright (C) 1999 Matthew Ramsay <matthewr@moreton.com.au>
 *			Chris Trew <ctrew@moreton.com.au>
 *
 * Rewrite by Russ Dill <Russ.Dill@asu.edu> July 2001
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <netinet/in.h>
#include <unistd.h>
#include <string.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <errno.h>
#include <features.h>
#if __GLIBC__ >=2 && __GLIBC_MINOR >= 1
#include <netpacket/packet.h>
#include <net/ethernet.h>
#else
#include <asm/types.h>
#include <linux/if_packet.h>
#include <linux/if_ether.h>
#endif

#include "socket.h"
#include "common.h"

int read_interface(char *interface, int *ifindex, uint32_t *addr, uint8_t *arp)
{
	int fd;
	struct ifreq ifr;
	struct sockaddr_in *our_ip;

	memset(&ifr, 0, sizeof(struct ifreq));
	if((fd = socket(AF_INET, SOCK_RAW, IPPROTO_RAW)) >= 0) {
		ifr.ifr_addr.sa_family = AF_INET;
		strcpy(ifr.ifr_name, interface);

		if (addr) { 
			if (ioctl(fd, SIOCGIFADDR, &ifr) == 0) {
				our_ip = (struct sockaddr_in *) &ifr.ifr_addr;
				*addr = our_ip->sin_addr.s_addr;
				DEBUG(LOG_INFO, "%s (our ip) = %s", ifr.ifr_name, inet_ntoa(our_ip->sin_addr));
			} else {
				LOG(LOG_ERR, "SIOCGIFADDR failed, is the interface up and configured?: %m");
				return -1;
			}
		}
		
		if (ioctl(fd, SIOCGIFINDEX, &ifr) == 0) {
			DEBUG(LOG_INFO, "adapter index %d", ifr.ifr_ifindex);
			*ifindex = ifr.ifr_ifindex;
		} else {
			LOG(LOG_ERR, "SIOCGIFINDEX failed!: %m");
			return -1;
		}
		if (ioctl(fd, SIOCGIFHWADDR, &ifr) == 0) {
			memcpy(arp, ifr.ifr_hwaddr.sa_data, 6);
			DEBUG(LOG_INFO, "adapter hardware address %02x:%02x:%02x:%02x:%02x:%02x",
				arp[0], arp[1], arp[2], arp[3], arp[4], arp[5]);
		} else {
			LOG(LOG_ERR, "SIOCGIFHWADDR failed!: %m");
			return -1;
		}
	} else {
		LOG(LOG_ERR, "socket failed!: %m");
		return -1;
	}
	close(fd);
	return 0;
}


int listen_socket(uint32_t ip, int port, char *inf)
{
	struct ifreq interface;
	int fd;
	struct sockaddr_in addr;
	int n = 1;

	DEBUG(LOG_INFO, "Opening listen socket on 0x%08x:%d %s", ip, port, inf);
	if ((fd = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0) {
		DEBUG(LOG_ERR, "dhcp socket call failed: %m");
		return -1;
	}
	
	memset(&addr, 0, sizeof(addr));
	addr.sin_family = AF_INET;
	addr.sin_port = htons(port);
	addr.sin_addr.s_addr = ip;

	if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, (char *) &n, sizeof(n)) == -1) {
		close(fd);
		return -1;
	}
	if (setsockopt(fd, SOL_SOCKET, SO_BROADCAST, (char *) &n, sizeof(n)) == -1) {
		close(fd);
		return -1;
	}

	strncpy(interface.ifr_ifrn.ifrn_name, inf, IFNAMSIZ);
	if (setsockopt(fd, SOL_SOCKET, SO_BINDTODEVICE,(char *)&interface, sizeof(interface)) < 0) {
		close(fd);
		return -1;
	}

	if (bind(fd, (struct sockaddr *)&addr, sizeof(struct sockaddr)) == -1) {
		close(fd);
		return -1;
	}
	
	return fd;
}

int arp_socket(char *inf, int ifindex)
{
	struct sockaddr_ll sll;
	int fd;

	DEBUG(LOG_INFO, "Opening arp socket on %s", inf);

	if ((fd = socket(PF_PACKET, SOCK_DGRAM, 0)) < 0) {
		DEBUG(LOG_ERR, "arp socket call failed: %m");
		return -1;
	}

	memset(&sll, 0, sizeof(sll));
	sll.sll_family = AF_PACKET;
	sll.sll_protocol = htons(ETH_P_ARP);
	sll.sll_ifindex = ifindex;
	if (bind(fd, (struct sockaddr*)&sll, sizeof(sll)) < 0) {
		close(fd);
		DEBUG(LOG_ERR, "arp bind call failed: %m");
		return -1;
	}

	return fd;
}

--========GMX142921208263642964444
Content-Type: text/plain; charset="iso-8859-15"; name="ippnpadd"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="ippnpadd"

#!/bin/ash

# $1 mac
# $2 gwip
# $3 leaseip
# $4 clientip
# $5 clientip +/- 1
# $6 interface

# $1 mac
# $2 leaseip
# $3 clientip
# $4 interface

. /system/data/network.cfg

if [ "$#" = "6" ]; then
	mac=$1
	gwip=$2
	leaseip=$3
	fixip=$4
	fixip1=$5
	interface=$6
else if [ "$#" = "4" ]; then
	mac=$1
	gwip=`echo $2 | awk -F \. '/./ { print $1 "." $2 "." $3 ".1" }'`
	leaseip=$2
	fixip=$3
	fixip1=`echo $3 | awk -F \. '/./ { if ($4 == 1) print $1 "." $2 "." $3 "." $4 + 1; else print $1 "." $2 "." $3 "." $4 - 1 }'`
	interface=$4
else
	logger ippnpadd wrong number of params
	exit
fi
fi

# check reserved subnet - if yes, do nothing (allow switches and APs to be managed from gateway
rsvsubnet=`echo $NET_LANIPADDRESS | awk -F \. '/./ { print $1 "." $2 "." $3 }'`
clientsubnet=`echo $fixip | awk -F \. '/./ { print $1 "." $2 "." $3 }'`
grep -i $fixip /system/data/ipdevices.cfg
if [ "$?" = 0 -o "$rsvsubnet" = "$clientsubnet" ]; then
	logger ippnpadd Reserved subnet request dropped for $fixip
	exit
fi

lanprefix=`echo $NET_LANLEASESTART | awk -F \. '/./ { print $1 "." $2 }'`
fixip1=$lanprefix.0.1

logger ippnpadd $mac $gwip $leaseip $fixip $fixip1 $interface

arptables -A OUTPUT -o $interface -d $leaseip -j mangle --mangle-ip-d $fixip --mangle-ip-s $fixip1
arptables -A INPUT -i $interface -s $fixip -j mangle --mangle-ip-s $leaseip --mangle-ip-d $gwip

iptables -t mangle -I PREROUTING -i $interface -s $fixip -j SADDR --to-source $leaseip
iptables -t mangle -I POSTROUTING -o $interface -d $leaseip -j DADDR --to-dest $fixip

dhcpd.sh dhcprequest $mac $leaseip $interface IPPNP

--========GMX142921208263642964444--
