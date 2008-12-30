From: Andreas Schultz <aschultz@warp10.net>
Subject: [RFC][PATCH] ipset - remove binding support
Date: Tue, 30 Dec 2008 17:33:26 +0100
Message-ID: <1230654806.10747.6.camel@ws-aschultz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-yk3BhxNxLhrJWcTQCu4c"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([213.187.84.201]:57446 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbYL3RH6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Dec 2008 12:07:58 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-yk3BhxNxLhrJWcTQCu4c
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

Whenever i'm playing with ipset (coding), i stumble over the binding
stuff. This has been depreciated since 2.4.0 and i think it's time to
start doing some work for the next major release.

So here is a patch that removes the binding support from ipset. I have
tried to only remove stuff without changing to much else. Once binding
is gone, some function calls and APIs can be simplified. But this should
IMHO go into a separate patch.

Comments?

Andreas

--=-yk3BhxNxLhrJWcTQCu4c
Content-Disposition: attachment; filename="ipset-remove-bindings-v1.patch"
Content-Type: text/x-patch; name="ipset-remove-bindings-v1.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/Makefile b/Makefile
index fbe20a2..63eed34 100644
--- a/Makefile
+++ b/Makefile
@@ -13,9 +13,6 @@ endif
 ifndef IP_NF_SET_MAX
 IP_NF_SET_MAX=256
 endif
-ifndef IP_NF_SET_HASHSIZE
-IP_NF_SET_HASHSIZE=1024
-endif
 ifndef V
 V=0
 endif
@@ -89,7 +86,7 @@ modules:
 	@[ -f $(KERNEL_DIR)/net/ipv4/netfilter/Kconfig ] || (echo "Error: The directory '$(KERNEL_DIR)' doesn't look like a Linux 2.6.x kernel source tree." && exit 1)
 	@[ -f $(KBUILD_OUTPUT)/.config ] || (echo "Error: The kernel source in '$(KERNEL_DIR)' must be configured" && exit 1)
 	@[ -f $(KBUILD_OUTPUT)/Module.symvers ] || echo "Warning: You should run 'make modules' in '$(KERNEL_DIR)' beforehand"
-	cd kernel; make -C $(KBUILD_OUTPUT) M=`pwd` V=$V IP_NF_SET_MAX=$(IP_NF_SET_MAX) IP_NF_SET_HASHSIZE=$(IP_NF_SET_HASHSIZE) modules
+	cd kernel; make -C $(KBUILD_OUTPUT) M=`pwd` V=$V IP_NF_SET_MAX=$(IP_NF_SET_MAX) modules
 
 modules_install: modules
 	cd kernel; make -C $(KBUILD_OUTPUT) M=`pwd` modules_install
diff --git a/README b/README
index a48782d..1d6630c 100644
--- a/README
+++ b/README
@@ -7,12 +7,10 @@ This is the ipset source tree. Follow these steps to install ipset:
 
    # make KERNEL_DIR=<<where-you-built-your-kernel>>
 
-   You can specify the maximum number of sets (default 256)
-   and/or the hash size for bindings (default 1024) if you want:
+   You can specify the maximum number of sets (default 256) if you want:
 
    # make KERNEL_DIR=<<where-you-built-your-kernel>> \
-	IP_NF_SET_MAX=<<your setsize number>> \
-	IP_NF_SET_HASHSIZE=<<your hashsize number>>
+	IP_NF_SET_MAX=<<your setsize number>>
 
 2. Install the binary and the modules
 
diff --git a/ipset.8 b/ipset.8
index 0d57869..3ebd200 100644
--- a/ipset.8
+++ b/ipset.8
@@ -28,9 +28,7 @@ ipset \- administration tool for IP sets
 .br
 .BR "ipset -[ADU] " "set entry"
 .br
-.BR "ipset -B " "set entry -b binding"
-.br
-.BR "ipset -T " "set entry [-b binding]"
+.BR "ipset -T " "set entry"
 .br
 .BR "ipset -R "
 .SH DESCRIPTION
@@ -40,16 +38,6 @@ kernel. Depending on the type, an IP set may store IP addresses, (TCP/UDP)
 port numbers or additional informations besides IP addresses: the word IP 
 means a general term here. See the set type definitions below.
 .P
-Any entry in a set can be bound to another set, which forms a relationship
-between a set element and the set it is bound to. In order to define a
-binding it is not required that the entry be already added to the set. 
-The sets may have a default binding, which is valid for every set element 
-for which there is no binding defined at all.
-.P
-IP set bindings pointing to sets and iptables matches and targets 
-referring to sets creates references, which protects the given sets in 
-the kernel. A set cannot be removed (destroyed) while there is a single
-reference pointing to it.
 .SH OPTIONS
 The options that are recognized by
 .B ipset
@@ -71,8 +59,6 @@ Destroy the specified set, or all sets if none or the keyword
 .B
 :all:
 is specified.
-Before destroying the set, all bindings belonging to the 
-set elements and the default binding of the set are removed.
 
 If the set has got references, nothing is done.
 .TP
@@ -81,7 +67,7 @@ Delete all entries from the specified set, or flush
 all sets if none or the keyword
 .B
 :all:
-is given. Bindings are not affected by the flush operation.
+is given.
 .TP
 .BI "-E, --rename " "\fIfrom-setname\fP \fIto-setname\fP"
 Rename a set. Set identified by to-setname must not exist.
@@ -92,7 +78,7 @@ exchange the name of two sets. The referred sets must exist and
 identical type of sets can be swapped only.
 .TP
 .BI "-L, --list " "[\fIsetname\fP]"
-List the entries and bindings for the specified set, or for
+List the entries for the specified set, or for
 all sets if none or the keyword
 .B
 :all:
@@ -115,9 +101,9 @@ Restore a saved session generated by --save. The saved session
 can be fed from stdin.
 
 When generating a session file please note that the supported commands
-(create set, add element, bind) must appear in a strict order: first create
+(create set, add element) must appear in a strict order: first create
 the set, then add all elements. Then create the next set, add all its elements
-and so on. Finally you can list all binding commands. Also, it is a restore
+and so on. Also, it is a restore
 operation, so the sets being restored must not exist.
 .TP
 .BI "-A, --add " "\fIsetname\fP \fIIP\fP"
@@ -126,61 +112,21 @@ Add an IP to a set.
 .BI "-D, --del " "\fIsetname\fP \fIIP\fP"
 Delete an IP from a set. 
 .TP
-.BI "-T, --test " "\fIsetname\fP \fIIP
+.BI "-T, --test " "\fIsetname\fP \fIIP"
 Test wether an IP is in a set or not. Exit status number is zero
 if the tested IP is in the set and nonzero if it is missing from 
 the set.
 .TP
-.BI "-T, --test " "\fIsetname\fP \fIIP\fP \fI--binding\fP \fIto-setname\fP"
-Test wether the IP belonging to the set points to the specified binding. 
-Exit status number is zero if the binding points to the specified set, 
-otherwise it is nonzero. The keyword
-.B
-:default:
-can be used to test the default binding of the set.
-.TP
-.BI "-B, --bind " "\fIsetname\fP \fIIP\fP \fI--binding\fP \fIto-setname\fP"
-Bind the IP in setname to to-setname.
-.TP
-.BI "-U, --unbind " "\fIsetname\fP \fIIP\fP"
-Delete the binding belonging to IP in set setname. 
-.TP
 .BI "-H, --help " "[settype]"
 Print help and settype specific help if settype specified.
-.P
-At the
-.B
--B, -U
-and
-.B 
--T
-commands you can use the token
-.B
-:default:
-to bind, unbind or test the default binding of a set instead
-of an IP. At the
-.B
--U
-command you can use the token
-.B
-:all:
-to destroy the bindings of all elements of a set.
 .SS "OTHER OPTIONS"
 The following additional options can be specified:
 .TP
-.B "-b, --binding setname"
-The option specifies the value of the binding for the
-.B "-B"
-binding command, for which it is a mandatory option.
-You can use it in the
-.B "-T"
-test command as well to test bindings.
-.TP
 .B "-s, --sorted"
 Sorted output. When listing sets, entries are listed sorted.
 .TP
 .B "-n, --numeric"
-Numeric output. When listing sets, bindings, IP addresses and 
+Numeric output. When listing sets, IP addresses and 
 port numbers will be printed in numeric format. By default the 
 program will try to display them as host names, network names 
 or services (whenever applicable), which can trigger
@@ -578,6 +524,9 @@ the set elements.
 .SH GENERAL RESTRICTIONS
 Setnames starting with colon (:) cannot be defined. Zero valued set 
 entries cannot be used with hash type of sets.
+.SH BINDINGS
+Bindings have been removed since ipset-2.5.0. As replacement, sets of
+ipportmap and ipportiphash types can be used.
 .SH COMMENTS
 If you want to store same size subnets from a given network
 (say /24 blocks from a /8 network), use the ipmap set type.
diff --git a/ipset.c b/ipset.c
index ba007e5..769d549 100644
--- a/ipset.c
+++ b/ipset.c
@@ -65,7 +65,7 @@ static unsigned int global_option_offset = 0;
 
 static const char cmdflags[] = { ' ',			/* CMD_NONE */ 
 	'N', 'X', 'F', 'E', 'W', 'L', 'S', 'R', 
-	'A', 'D', 'T', 'B', 'U', 'H', 'V',
+	'A', 'D', 'T', 'H', 'V',
 };
 
 /* Options */
@@ -74,9 +74,8 @@ static const char cmdflags[] = { ' ',			/* CMD_NONE */
 #define OPT_SORTED		0x0002U		/* -s */
 #define OPT_QUIET		0x0004U		/* -q */
 #define OPT_DEBUG		0x0008U		/* -z */
-#define OPT_BINDING		0x0010U		/* -b */
-#define OPT_RESOLVE		0x0020U		/* -r */
-#define NUMBER_OF_OPT 6
+#define OPT_RESOLVE		0x0010U		/* -r */
+#define NUMBER_OF_OPT 5
 static const char optflags[] =
     { 'n', 's', 'q', 'z', 'b', 'r' };
 
@@ -97,15 +96,10 @@ static struct option opts_long[] = {
 	{"del",     1, 0, 'D'},
 	{"test",    1, 0, 'T'},
 	
-	/* binding operations */
-	{"bind",    1, 0, 'B'},
-	{"unbind",  1, 0, 'U'},
-	
 	/* free options */
 	{"numeric", 0, 0, 'n'},
 	{"sorted",  0, 0, 's'},
 	{"quiet",   0, 0, 'q'},
-	{"binding", 1, 0, 'b'},
 	{"resolve", 0, 0, 'r'},
 
 #ifdef IPSET_DEBUG
@@ -122,7 +116,7 @@ static struct option opts_long[] = {
 };
 
 static char opts_short[] =
-    "-N:X::F::E:W:L::S::RA:D:T:B:U:nrsqzb:Vh::H::";
+    "-N:X::F::E:W:L::S::RA:D:T:nrsqzVh::H::";
 
 /* Table of legal combinations of commands and options. If any of the
  * given commands make an option legal, that option is legal.
@@ -133,22 +127,20 @@ static char opts_short[] =
  */
 
 static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] = {
-	/*            -n   -s   -q   -z   -b  */
-	 /*CREATE*/  {'x', 'x', ' ', ' ', 'x', 'x'},
-	 /*DESTROY*/ {'x', 'x', ' ', ' ', 'x', 'x'},
-	 /*FLUSH*/   {'x', 'x', ' ', ' ', 'x', 'x'},
-	 /*RENAME*/  {'x', 'x', ' ', ' ', 'x', 'x'},
-	 /*SWAP*/    {'x', 'x', ' ', ' ', 'x', 'x'},
-	 /*LIST*/    {' ', ' ', 'x', ' ', 'x', ' '},
-	 /*SAVE*/    {'x', 'x', ' ', ' ', 'x', 'x'},
-	 /*RESTORE*/ {'x', 'x', ' ', ' ', 'x', 'x'},
-	 /*ADD*/     {'x', 'x', ' ', ' ', 'x', 'x'},
-	 /*DEL*/     {'x', 'x', ' ', ' ', 'x', 'x'},
-	 /*TEST*/    {'x', 'x', ' ', ' ', ' ', 'x'},
-	 /*BIND*/    {'x', 'x', ' ', ' ', '+', 'x'},
-	 /*UNBIND*/  {'x', 'x', ' ', ' ', 'x', 'x'},
-	 /*HELP*/    {'x', 'x', 'x', ' ', 'x', 'x'},
-	 /*VERSION*/ {'x', 'x', 'x', ' ', 'x', 'x'},
+	/*            -n   -s   -q   -z   -r  */
+	 /*CREATE*/  {'x', 'x', ' ', ' ', 'x'},
+	 /*DESTROY*/ {'x', 'x', ' ', ' ', 'x'},
+	 /*FLUSH*/   {'x', 'x', ' ', ' ', 'x'},
+	 /*RENAME*/  {'x', 'x', ' ', ' ', 'x'},
+	 /*SWAP*/    {'x', 'x', ' ', ' ', 'x'},
+	 /*LIST*/    {' ', ' ', 'x', ' ', ' '},
+	 /*SAVE*/    {'x', 'x', ' ', ' ', 'x'},
+	 /*RESTORE*/ {'x', 'x', ' ', ' ', 'x'},
+	 /*ADD*/     {'x', 'x', ' ', ' ', 'x'},
+	 /*DEL*/     {'x', 'x', ' ', ' ', 'x'},
+	 /*TEST*/    {'x', 'x', ' ', ' ', 'x'},
+	 /*HELP*/    {'x', 'x', 'x', ' ', 'x'},
+	 /*VERSION*/ {'x', 'x', 'x', ' ', 'x'},
 };
 
 /* Main parser function */
@@ -591,11 +583,6 @@ char *ip_tostring(ip_set_ip_t ip, unsigned options)
 	return inet_ntoa(addr);
 }
 
-char *binding_ip_tostring(struct set *set UNUSED,
-			  ip_set_ip_t ip, unsigned options)
-{
-	return ip_tostring(ip, options);
-}
 char *ip_tostring_numeric(ip_set_ip_t ip)
 {
 	return ip_tostring(ip, OPT_NUMERIC);
@@ -955,7 +942,7 @@ static void set_restore_create(const char *name, struct settype *settype)
 {
 	struct set *set;
 	
-	DP("%s %s %u %u %u %u", name, settype->typename,
+	DP("%s %s %zu %zu %zu %u", name, settype->typename,
 	   restore_offset, sizeof(struct ip_set_restore),
 	   settype->create_size, restore_size);
 
@@ -1112,46 +1099,14 @@ tryagain:
 		   set->name, set->settype->typename, set->index);
 		size += sizeof(struct ip_set_name_list);
 	}
-	/* Size to get set members, bindings */
+	/* Size to get set members */
 	size = ((struct ip_set_req_setnames *)data)->size;
 	free(data);
 	
 	return size;
 }
 
-/*
- * Save operation
- */
-static size_t save_bindings(void *data, size_t offset, size_t len)
-{
-	struct ip_set_hash_save *hash =
-		(struct ip_set_hash_save *) (data + offset);
-	struct set *set;
-
-	DP("offset %u, len %u", offset, len);
-	if (offset + sizeof(struct ip_set_hash_save) > len)
-		exit_error(OTHER_PROBLEM,
-			   "Save operation failed, try again later.");
-
-	set = set_find_byid(hash->id);
-	if (!(set && set_list[hash->binding]))
-		exit_error(OTHER_PROBLEM,
-			   "Save binding failed, try again later.");
-	if (!set->settype->bindip_tostring)
-		exit_error(OTHER_PROBLEM,
-			   "Internal error, binding is not supported with set %s"
-			   " of settype %s\n",
-			   set->name, set->settype->typename);
-	printf("-B %s %s -b %s\n",
-		set->name,
-		set->settype->bindip_tostring(set, hash->ip, OPT_NUMERIC),
-		set_list[hash->binding]->name);
-
-	return sizeof(struct ip_set_hash_save);
-}		
-
-static size_t save_set(void *data, int *bindings,
-		       size_t offset, size_t len)
+static size_t save_set(void *data, size_t offset, size_t len)
 {
 	struct ip_set_save *set_save =
 		(struct ip_set_save *) (data + offset);
@@ -1159,7 +1114,7 @@ static size_t save_set(void *data, int *bindings,
 	struct settype *settype;
 	size_t used;
 	
-	DP("offset %u (%u/%u/%u), len %u", offset,
+	DP("offset %zu (%lu/%zu/%zu), len %zu", offset,
 	   sizeof(struct ip_set_save), 
 	   set_save->header_size, set_save->members_size, 
 	   len);
@@ -1170,11 +1125,9 @@ static size_t save_set(void *data, int *bindings,
 			   "Save operation failed, try again later.");
 
 	DP("index: %u", set_save->index);
-	if (set_save->index == IP_SET_INVALID_ID) {
-		/* Marker */
-		*bindings = 1;
+	if (set_save->index == IP_SET_INVALID_ID)
 		return sizeof(struct ip_set_save);
-	}
+
 	set = set_list[set_save->index];
 	if (!set)
 		exit_error(OTHER_PROBLEM,
@@ -1196,39 +1149,12 @@ static size_t save_set(void *data, int *bindings,
 	return (used + set_save->members_size);
 }
 
-static size_t save_default_bindings(void *data, int *bindings)
-{
-	struct ip_set_save *set_save = (struct ip_set_save *) data;
-	struct set *set;
-	
-	if (set_save->index == IP_SET_INVALID_ID) {
-		/* Marker */
-		*bindings = 1;
-		return sizeof(struct ip_set_save);
-	}
-
-	set = set_list[set_save->index];
-	DP("%s, binding %u", set->name, set_save->binding);
-	if (set_save->binding != IP_SET_INVALID_ID) {
-		if (!set_list[set_save->binding])
-			exit_error(OTHER_PROBLEM,
-				   "Save set failed, try again later.");
-
-		printf("-B %s %s -b %s\n",
-			set->name, IPSET_TOKEN_DEFAULT, 
-			set_list[set_save->binding]->name);
-	}
-	return (sizeof(struct ip_set_save)
-	        + set_save->header_size
-	        + set_save->members_size);
-}
-
 static int try_save_sets(const char name[IP_SET_MAXNAMELEN])
 {
 	void *data = NULL;
 	socklen_t size, req_size = 0;
 	ip_set_id_t idx;
-	int res = 0, bindings = 0;
+	int res = 0;
 	time_t now = time(NULL);
 
 	/* Load set_list from kernel */
@@ -1236,7 +1162,7 @@ static int try_save_sets(const char name[IP_SET_MAXNAMELEN])
 			     IP_SET_OP_SAVE_SIZE, CMD_SAVE);
 	
 	if (size) {
-		/* Get sets, bindings and print them */
+		/* Get sets and print them */
 		/* Take into account marker */
 		req_size = (size += sizeof(struct ip_set_save));
 		data = ipset_malloc(size);
@@ -1254,16 +1180,8 @@ static int try_save_sets(const char name[IP_SET_MAXNAMELEN])
 	size = 0;
 	while (size < req_size) {
 		DP("size: %u, req_size: %u", size, req_size);
-		if (bindings)
-			size += save_bindings(data, size, req_size);
-		else
-			size += save_set(data, &bindings, size, req_size);
+		size += save_set(data, size, req_size);
 	}
-	/* Re-read data to save default bindings */
-	bindings = 0;
-	size = 0;
-	while (size < req_size && bindings == 0)
-		size += save_default_bindings(data + size, &bindings);
 
 	printf("COMMIT\n");
 	now = time(NULL);
@@ -1362,7 +1280,7 @@ static void set_restore(char *argv0)
 	char buffer[1024];	
 	char *ptr, *name = NULL;
 	char cmd = ' ';
-	int first_pass, i, bindings = 0;
+	int first_pass, i;
 	struct settype *settype = NULL;
 	struct ip_set_req_setnames *header;
 	ip_set_id_t idx;
@@ -1394,14 +1312,13 @@ static void set_restore(char *argv0)
 			break;
 		}
 			
-		/* -N, -A or -B */
+		/* -N or -A */
 		ptr = strtok(buffer, " \t\n");
 		DP("ptr: %s", ptr);
 		if (ptr == NULL
 		    || ptr[0] != '-'
 		    || !(ptr[1] == 'N'
-		         || ptr[1] == 'A'
-			 || ptr[1] == 'B')
+		         || ptr[1] == 'A')
 		    || ptr[2] != '\0') {
 			exit_error(PARAMETER_PROBLEM,
 				   "Line %u does not start as a valid restore command\n",
@@ -1425,10 +1342,6 @@ static void set_restore(char *argv0)
 			        exit_error(PARAMETER_PROBLEM,
 			        	   "Missing settype in line %u\n",
 		        		   restore_line);
-			if (bindings)
-			        exit_error(PARAMETER_PROBLEM,
-			        	   "Invalid line %u: create must precede bindings\n",
-		        		   restore_line);
 			settype = check_set_typename(ptr);
 			restore_size += sizeof(struct ip_set_restore)
 					+ settype->create_size;
@@ -1442,20 +1355,10 @@ static void set_restore(char *argv0)
 			        	   "Add IP to set %s in line %u without "
 					   "preceding corresponding create set line\n",
 		        		   ptr, restore_line);
-			if (bindings)
-			        exit_error(PARAMETER_PROBLEM,
-			        	   "Invalid line %u: adding entries must precede bindings\n",
-		        		   restore_line);
 			restore_size += settype->adt_size;
 			DP("restore_size (A): %u", restore_size);
 			break;
 		}
-		case 'B': {
-			bindings = 1;
-			restore_size += sizeof(struct ip_set_hash_save);
-			DP("restore_size (B): %u", restore_size);
-			break;
-		}
 		default: {
 			exit_error(PARAMETER_PROBLEM,
 		       		   "Unrecognized restore command in line %u\n",
@@ -1504,10 +1407,8 @@ static void set_restore(char *argv0)
 	exit_error(PARAMETER_PROBLEM,
 	      	   "Broken restore file\n");
    do_restore:
-   	if (bindings == 0
-   	    && restore_size == 
+   	if (restore_size == 
    	       (restore_offset + sizeof(struct ip_set_restore))) {
-   		/* No bindings */
 		struct ip_set_restore *marker = 
 			(struct ip_set_restore *) (restore_data + restore_offset);
 
@@ -1576,7 +1477,7 @@ static int set_adtip(struct set *set, const char *adt,
 
 	/* Alloc memory for the data to send */
 	size = sizeof(struct ip_set_req_adt) + set->settype->adt_size ;
-	DP("alloc size %i", size);
+	DP("alloc size %zi", size);
 	data = ipset_malloc(size);
 
 	/* Fill out the request */
@@ -1632,144 +1533,9 @@ static void set_restore_add(struct set *set, const char *adt UNUSED)
 }
 
 /*
- * Send bind/unbind/test binding order to kernel for a set
- */
-static int set_bind(struct set *set, const char *adt,
-		    const char *binding,
-		    unsigned op, unsigned cmd)
-{
-	struct ip_set_req_bind *req_bind;
-	size_t size;
-	void *data;
-	int res = 0;
-
-	/* set may be null: '-U :all: :all:|:default:' */
-	DP("(%s, %s) -> %s", set ? set->name : IPSET_TOKEN_ALL, adt, binding);
-
-	/* Ugly */
-	if (set != NULL
-	    && ((strcmp(set->settype->typename, "iptreemap") == 0)
-	        || (strcmp(set->settype->typename, "ipportiphash") == 0)
-	        || (strcmp(set->settype->typename, "ipportnethash") == 0)
-	        || (strcmp(set->settype->typename, "setlist") == 0)))
-		exit_error(PARAMETER_PROBLEM,
-			"%s type of sets cannot be used at binding operations\n",
-			set->settype->typename);
-	/* Alloc memory for the data to send */
-	size = sizeof(struct ip_set_req_bind);
-	if (op != IP_SET_OP_UNBIND_SET && adt[0] == ':')
-		/* Set default binding */
-		size += IP_SET_MAXNAMELEN;
-	else if (!(op == IP_SET_OP_UNBIND_SET && set == NULL))
-		size += set->settype->adt_size;
-	DP("alloc size %i", size);
-	data = ipset_malloc(size);
-
-	/* Fill out the request */
-	req_bind = (struct ip_set_req_bind *) data;
-	req_bind->op = op;
-	req_bind->index = set ? set->index : IP_SET_INVALID_ID;
-	if (adt[0] == ':') {
-		/* ':default:' and ':all:' */
-		strncpy(req_bind->binding, adt, IP_SET_MAXNAMELEN);
-		if (op != IP_SET_OP_UNBIND_SET && adt[0] == ':')
-			strncpy(data + sizeof(struct ip_set_req_bind),
-				binding, IP_SET_MAXNAMELEN);
-	} else {
-		strncpy(req_bind->binding, binding, IP_SET_MAXNAMELEN);
-		memcpy(data + sizeof(struct ip_set_req_bind),
-		       set->settype->data, set->settype->adt_size);
-	}
-
-	if (op == IP_SET_OP_TEST_BIND_SET) {
-		if (kernel_sendto_handleerrno(cmd, data, size) == -1) {
-			ipset_printf("%s in set %s is bound to %s.",
-				     adt, set->name, binding);
-			res = 0;
-		} else {
-			ipset_printf("%s in set %s is NOT bound to %s.",
-				     adt, set->name, binding);
-			res = 1;
-		}
-	} else 	
-		kernel_sendto(cmd, data, size);
-	free(data);
-
-	return res;
-}
-
-static void set_restore_bind(struct set *set,
-			     const char *adt,
-			     const char *binding)
-{
-	struct ip_set_hash_save *hash_restore;
-
-	if (restore == 1) {
-		/* Marker */
-		struct ip_set_restore *marker = 
-			(struct ip_set_restore *) (restore_data + restore_offset);
-
-		DP("restore marker");
-		if (restore_offset + sizeof(struct ip_set_restore) 
-		    > restore_size)
-		    	exit_error(PARAMETER_PROBLEM,
-		    		   "Giving up, restore file is screwed up!");
-		marker->index = IP_SET_INVALID_ID;
-		marker->header_size = marker->members_size = 0;
-		restore_offset += sizeof(struct ip_set_restore);
-		restore = 2;
-	}
-	/* Sanity checking */
-	if (restore_offset + sizeof(struct ip_set_hash_save) > restore_size)
-	    	exit_error(PARAMETER_PROBLEM,
-	    		   "Giving up, restore file is screwed up!");
-
-	hash_restore = (struct ip_set_hash_save *) (restore_data + restore_offset);
-	DP("%s -> %s", adt, binding);
-	if (strcmp(adt, IPSET_TOKEN_DEFAULT) == 0)
-		hash_restore->ip = 0;
-	else {
-		if (!set->settype->bindip_parse)
-			exit_error(OTHER_PROBLEM,
-				   "Internal error, binding is not supported with set %s"
-				   " of settype %s\n",
-				   set->name, set->settype->typename);
-		set->settype->bindip_parse(adt, &hash_restore->ip);
-	}
-	hash_restore->id = set->index;	    		   
-	hash_restore->binding = (set_find_byname(binding))->index;	
-	DP("id %u, ip %u, binding %u",
-	   hash_restore->id, hash_restore->ip, hash_restore->binding);
-	restore_offset += sizeof(struct ip_set_hash_save);
-}
-
-/*
  * Print operation
  */
 
-static void print_bindings(struct set *set,
-			   void *data, size_t size, unsigned options,
-			   char * (*printip)(struct set *set, 
-					     ip_set_ip_t ip, unsigned options))
-{
-	size_t offset = 0;
-	struct ip_set_hash_list *hash;
-
-	if (offset < size && !printip)
-		exit_error(OTHER_PROBLEM,
-			   "Internal error, binding is not supported with set %s"
-			   " of settype %s\n",
-			   set->name, set->settype->typename);
-
-	while (offset < size) {
-		hash = (struct ip_set_hash_list *) (data + offset);
-		printf("%s -> %s\n", 
-			printip(set, hash->ip, options),
-			set_list[hash->binding]->name);
-		offset += sizeof(struct ip_set_hash_list);
-	}
-}
-
 /* Help function to set_list() */
 static size_t print_set(void *data, unsigned options)
 {
@@ -1782,9 +1548,6 @@ static size_t print_set(void *data, unsigned options)
 	printf("Name: %s\n", set->name);
 	printf("Type: %s\n", settype->typename);
 	printf("References: %d\n", setlist->ref);
-	printf("Default binding: %s\n",
-	       setlist->binding == IP_SET_INVALID_ID ? ""
-	       : set_list[setlist->binding]->name);
 
 	/* Init header */
 	offset = sizeof(struct ip_set_list);
@@ -1804,17 +1567,10 @@ static size_t print_set(void *data, unsigned options)
 		settype->printips(set, data + offset,
 				  setlist->members_size, options);
 
-	/* Print bindings */
-	printf("Bindings:\n");
+	printf("\n");		/* One newline between sets */
 	offset += setlist->members_size;
-	if (set->settype->bindip_tostring)
-		print_bindings(set,
-		       data + offset, setlist->bindings_size, options,
-		       settype->bindip_tostring);
 
-	printf("\n");		/* One newline between sets */
-	
-	return (offset + setlist->bindings_size);
+	return offset;
 }
 
 static int try_list_sets(const char name[IP_SET_MAXNAMELEN],
@@ -1885,14 +1641,12 @@ static void set_help(const struct settype *settype)
 	       "Usage: %s -N new-set settype [options]\n"
 	       "       %s -[XFLSH] [set] [options]\n"
 	       "       %s -[EW] from-set to-set\n"
-	       "       %s -[ADTU] set IP\n"
-	       "       %s -B set IP option\n"
+	       "       %s -[ADT] set IP\n"
 	       "       %s -R\n"
 	       "       %s -h (print this help information)\n\n",
 	       program_name, program_version, 
 	       program_name, program_name, program_name,
-	       program_name, program_name, program_name,
-	       program_name);
+	       program_name, program_name, program_name);
 
 	printf("Commands:\n"
 	       "Either long or short options are allowed.\n"
@@ -1918,13 +1672,6 @@ static void set_help(const struct settype *settype)
 	       "                    Deletes an IP from a set\n"
 	       "  --test    -T setname IP \n"
 	       "                    Tests if an IP exists in a set.\n"
-	       "  --bind    -B setname IP|:default: -b bind-setname\n"
-	       "                    Bind the IP in setname to bind-setname.\n"
-	       "  --unbind  -U setname IP|:all:|:default:\n"
-	       "                    Delete binding belonging to IP,\n"
-	       "                    all bindings or default binding of setname.\n"
-	       "  --unbind  -U :all: :all:|:default:\n"
-	       "                    Delete all bindings or all default bindings.\n"
 	       "  --help    -H [settype]\n"
 	       "                    Prints this help, and settype specific help\n"
 	       "  --version -V\n"
@@ -1933,8 +1680,7 @@ static void set_help(const struct settype *settype)
 	       "  --sorted     -s   Numeric sort of the IPs in -L\n"
 	       "  --numeric    -n   Numeric output of addresses in a -L (default)\n"
 	       "  --resolve    -r   Try to resolve addresses in a -L\n"
-	       "  --quiet      -q   Suppress any output to stdout and stderr.\n"
-	       "  --binding    -b   Specifies the binding for -B\n");
+	       "  --quiet      -q   Suppress any output to stdout and stderr.\n");
 #ifdef IPSET_DEBUG
 	printf("  --debug      -z   Enable debugging\n\n");
 #else
@@ -1966,22 +1712,6 @@ static int parse_adt_cmdline(int command,
 {
 	int res = 0;
 
-	/* -U :all: :all:|:default: */
-	if (command == CMD_UNBIND) {
-		if (strcmp(name, IPSET_TOKEN_ALL) == 0) {
-			if (strcmp(adt, IPSET_TOKEN_DEFAULT) == 0
-			    || strcmp(adt, IPSET_TOKEN_ALL) == 0) {
-			    	*set = NULL;
-			    	*settype = NULL;
-			    	return 1;
-			} else
-				exit_error(PARAMETER_PROBLEM,
-					   "-U %s requires %s or %s as binding name",
-					   IPSET_TOKEN_ALL,
-					   IPSET_TOKEN_DEFAULT,
-					   IPSET_TOKEN_ALL);
-		}
-	}
 	*set = restore ? set_find_byname(name)
 		       : set_adt_get(name);
 					
@@ -1989,9 +1719,7 @@ static int parse_adt_cmdline(int command,
 	*settype = (*set)->settype;
 	memset((*settype)->data, 0, (*settype)->adt_size);
 
-	if ((command == CMD_TEST
-	     || command == CMD_BIND
-	     || command == CMD_UNBIND)
+	if (command == CMD_TEST
 	    && (strcmp(adt, IPSET_TOKEN_DEFAULT) == 0
 		|| strcmp(adt, IPSET_TOKEN_ALL) == 0))
 		res = 1;
@@ -2014,9 +1742,8 @@ int parse_commandline(int argc, char *argv[])
 	
 	char *name = NULL;		/* All except -H, -R */
 	char *newname = NULL;		/* -E, -W */
-	char *adt = NULL;		/* -A, -D, -T, -B, -U */
-	char *binding = NULL;		/* -B */
-	struct set *set = NULL;		/* -A, -D, -T, -B, -U */
+	char *adt = NULL;		/* -A, -D, -T */
+	struct set *set = NULL;		/* -A, -D, -T */
 	struct settype *settype = NULL;	/* -N, -H */
 	char all_sets[] = IPSET_TOKEN_ALL;
 	
@@ -2063,7 +1790,7 @@ int parse_commandline(int argc, char *argv[])
 
 				name = check_set_name(optarg);
 				
-				/* Protect reserved names (binding) */
+				/* Protect reserved names */
 				if (name[0] == ':')
 					exit_error(PARAMETER_PROBLEM,
 						   "setname might not start with colon",
@@ -2138,9 +1865,7 @@ int parse_commandline(int argc, char *argv[])
 
 		case 'A':	/* Add IP */
 		case 'D':	/* Del IP */
-		case 'T':	/* Test IP */
-		case 'B':	/* Bind IP */
-		case 'U':{	/* Unbind IP */
+		case 'T':{	/* Test IP */
 				set_command(&command, find_cmd(c));
 
 				name = check_set_name(optarg);
@@ -2193,11 +1918,6 @@ int parse_commandline(int argc, char *argv[])
 			break;
 #endif
 
-		case 'b':
-			add_option(&options, OPT_BINDING);
-			binding = check_set_name(optarg);
-			break;
-
 		case 1:	/* non option */
 			printf("Bad argument `%s'\n", optarg);
 			exit_tryhelp(PARAMETER_PROBLEM);
@@ -2294,26 +2014,7 @@ int parse_commandline(int argc, char *argv[])
 		break;
 
 	case CMD_TEST:
-		if (binding)
-			res = set_bind(set, adt, binding, 
-				       IP_SET_OP_TEST_BIND_SET, CMD_TEST);
-		else
-			res = set_adtip(set, adt, 
-					IP_SET_OP_TEST_IP, CMD_TEST);
-		break;
-
-	case CMD_BIND:
-		fprintf(stderr, "Warning: binding will be removed from the next release.\n"
-			        "Please replace bindigs with sets of ipportmap and ipportiphash types\n");
-		if (restore)
-			set_restore_bind(set, adt, binding);
-		else
-			set_bind(set, adt, binding,
-				 IP_SET_OP_BIND_SET, CMD_BIND);
-		break;
-
-	case CMD_UNBIND:
-		set_bind(set, adt, "", IP_SET_OP_UNBIND_SET, CMD_UNBIND);
+		res = set_adtip(set, adt, IP_SET_OP_TEST_IP, CMD_TEST);
 		break;
 
 	case CMD_HELP:
diff --git a/ipset.h b/ipset.h
index 2596dfa..179257f 100644
--- a/ipset.h
+++ b/ipset.h
@@ -56,8 +56,6 @@ enum set_commands {
 	CMD_ADD,		/* -A */
 	CMD_DEL,		/* -D */
 	CMD_TEST,		/* -T */
-	CMD_BIND,		/* -B */
-	CMD_UNBIND,		/* -U */
 	CMD_HELP,		/* -H */
 	CMD_VERSION,		/* -V */
 	NUMBER_OF_CMD = CMD_VERSION,
@@ -145,12 +143,6 @@ struct settype {
 	/* Print save for all IPs */
 	void (*saveips) (struct set *set, void *data, size_t len, unsigned options);
 
-	/* Conver a single IP (binding) to string */
-	char * (*bindip_tostring)(struct set *set, ip_set_ip_t ip, unsigned options);
-	
-	/* Parse an IP at restoring bindings. FIXME */
-	void (*bindip_parse) (const char *str, ip_set_ip_t * ip);
-
 	/* Print usage */
 	void (*usage) (void);
 
@@ -167,8 +159,6 @@ extern void settype_register(struct settype *settype);
 
 extern void exit_error(int status, const char *msg, ...);
 
-extern char *binding_ip_tostring(struct set *set,
-				 ip_set_ip_t ip, unsigned options);
 extern char *ip_tostring(ip_set_ip_t ip, unsigned options);
 extern char *ip_tostring_numeric(ip_set_ip_t ip);
 extern void parse_ip(const char *str, ip_set_ip_t * ip);
diff --git a/ipset_iphash.c b/ipset_iphash.c
index edc22fb..807860a 100644
--- a/ipset_iphash.c
+++ b/ipset_iphash.c
@@ -269,10 +269,6 @@ static struct settype settype_iphash = {
 	.saveheader = &saveheader,
 	.saveips = &saveips,
 	
-	/* Bindings */
-	.bindip_tostring = &binding_ip_tostring,
-	.bindip_parse = &parse_ip,
-	
 	.usage = &usage,
 };
 
diff --git a/ipset_ipmap.c b/ipset_ipmap.c
index fed93d9..72adbdb 100644
--- a/ipset_ipmap.c
+++ b/ipset_ipmap.c
@@ -328,10 +328,6 @@ static struct settype settype_ipmap = {
 	.saveheader = &saveheader,
 	.saveips = &saveips,
 	
-	/* Bindings */
-	.bindip_tostring = &binding_ip_tostring,
-	.bindip_parse	= &parse_ip,
-
 	.usage = &usage,
 };
 
diff --git a/ipset_ipporthash.c b/ipset_ipporthash.c
index fa816c9..9f2dd7a 100644
--- a/ipset_ipporthash.c
+++ b/ipset_ipporthash.c
@@ -304,22 +304,6 @@ saveips(struct set *set, void *data, size_t len, unsigned options)
 	}
 }
 
-static char buffer[22];
-
-static char *
-unpack_ipport_tostring(struct set *set, ip_set_ip_t bip, unsigned options)
-{
-	struct ip_set_ipporthash *mysetdata = set->settype->header;
-	ip_set_ip_t ip, port;
-	
-	ip = (bip>>16) + mysetdata->first_ip;
-	port = (uint16_t) bip;
-	sprintf(buffer, "%s,%s", 
-		ip_tostring(ip, options), port_tostring(port, options));
-		
-	return buffer;
-}
-
 static void usage(void)
 {
 	printf
@@ -356,10 +340,6 @@ static struct settype settype_ipporthash = {
 	.saveheader = &saveheader,
 	.saveips = &saveips,
 	
-	/* Bindings */
-	.bindip_tostring = &unpack_ipport_tostring,
-	.bindip_parse = &parse_ip,
-	
 	.usage = &usage,
 };
 
diff --git a/ipset_iptree.c b/ipset_iptree.c
index 09f11db..7273267 100644
--- a/ipset_iptree.c
+++ b/ipset_iptree.c
@@ -211,10 +211,6 @@ static struct settype settype_iptree = {
 	.saveheader = &saveheader,
 	.saveips = &saveips,
 	
-	/* Bindings */
-	.bindip_tostring = &binding_ip_tostring,
-	.bindip_parse	= &parse_ip,
-
 	.usage = &usage,
 };
 
diff --git a/ipset_iptreemap.c b/ipset_iptreemap.c
index 81bc8f3..fb8b4a4 100644
--- a/ipset_iptreemap.c
+++ b/ipset_iptreemap.c
@@ -198,9 +198,6 @@ static struct settype settype_iptreemap = {
 	.saveheader = &saveheader,
 	.saveips = &saveips,
 
-	.bindip_tostring = &binding_ip_tostring,
-	.bindip_parse = &parse_ip,
-
 	.usage = &usage,
 };
 
diff --git a/ipset_macipmap.c b/ipset_macipmap.c
index 186e68e..1fc0c4f 100644
--- a/ipset_macipmap.c
+++ b/ipset_macipmap.c
@@ -333,10 +333,6 @@ static struct settype settype_macipmap = {
 	.saveheader = &saveheader,
 	.saveips = &saveips,
 
-	/* Bindings */
-	.bindip_tostring = &binding_ip_tostring,
-	.bindip_parse = &parse_ip,
-
 	.usage = &usage,
 };
 
diff --git a/ipset_nethash.c b/ipset_nethash.c
index 9c9d6ac..1ad4db2 100644
--- a/ipset_nethash.c
+++ b/ipset_nethash.c
@@ -263,35 +263,6 @@ saveips(struct set *set UNUSED, void *data, size_t len, unsigned options)
 	}
 }
 
-static char *
-net_tostring(struct set *set UNUSED, ip_set_ip_t ip, unsigned options)
-{
-	return unpack_ip_tostring(ip, options);
-}
-
-static void
-parse_net(const char *str, ip_set_ip_t *ip)
-{
-	char *saved = ipset_strdup(str);
-	char *ptr, *tmp = saved;
-	ip_set_ip_t cidr;
-
-	ptr = strsep(&tmp, "/");
-	
-	if (tmp == NULL)
-		exit_error(PARAMETER_PROBLEM,
-			   "Missing cidr from `%s'", str);
-
-	if (string_to_number(tmp, 1, 31, &cidr))
-		exit_error(PARAMETER_PROBLEM,
-			   "Out of range cidr `%s' specified", str);
-	
-	parse_ip(ptr, ip);
-	ipset_free(saved);
-	
-	*ip = pack_ip_cidr(*ip, cidr);
-}
-
 static void usage(void)
 {
 	printf
@@ -326,10 +297,6 @@ static struct settype settype_nethash = {
 	.saveheader = &saveheader,
 	.saveips = &saveips,
 	
-	/* Bindings */
-	.bindip_tostring = &net_tostring,
-	.bindip_parse = &parse_net,
-
 	.usage = &usage,
 };
 
diff --git a/ipset_portmap.c b/ipset_portmap.c
index b86dbb2..5e30ceb 100644
--- a/ipset_portmap.c
+++ b/ipset_portmap.c
@@ -162,13 +162,6 @@ printports_sorted(struct set *set, void *data,
 	}
 }
 
-static char *
-binding_port_tostring(struct set *set UNUSED,
-		      ip_set_ip_t ip, unsigned options)
-{
-	return port_tostring(ip, options);
-}
-
 static void
 saveheader(struct set *set, unsigned options)
 {
@@ -231,10 +224,6 @@ static struct settype settype_portmap = {
 	.saveheader = &saveheader,
 	.saveips = &saveports,
 	
-	/* Bindings */
-	.bindip_tostring = &binding_port_tostring,
-	.bindip_parse = &parse_port,
-
 	.usage = &usage,
 };
 
diff --git a/kernel/Config.in.ipset b/kernel/Config.in.ipset
index 0f442e7..14a178e 100644
--- a/kernel/Config.in.ipset
+++ b/kernel/Config.in.ipset
@@ -1,7 +1,6 @@
   dep_tristate '  IP set support' CONFIG_IP_NF_SET $CONFIG_IP_NF_IPTABLES
   if [ "$CONFIG_IP_NF_SET" != "n" ]; then
     int '     Maximum number of sets' CONFIG_IP_NF_SET_MAX 256
-    int '     Hash size for bindings of IP sets' CONFIG_IP_NF_SET_HASHSIZE 1024
     dep_tristate '    set match support' CONFIG_IP_NF_MATCH_SET $CONFIG_IP_NF_SET
     dep_tristate '    SET target support' CONFIG_IP_NF_TARGET_SET $CONFIG_IP_NF_SET
     dep_tristate '    ipmap set type support' CONFIG_IP_NF_SET_IPMAP $CONFIG_IP_NF_SET
diff --git a/kernel/Kbuild b/kernel/Kbuild
index 9757a4a..694b293 100644
--- a/kernel/Kbuild
+++ b/kernel/Kbuild
@@ -1,6 +1,5 @@
 EXTRA_CFLAGS := -I$(M)/include \
-	-DCONFIG_IP_NF_SET_MAX=$(IP_NF_SET_MAX) \
-	-DCONFIG_IP_NF_SET_HASHSIZE=$(IP_NF_SET_HASHSIZE)
+	-DCONFIG_IP_NF_SET_MAX=$(IP_NF_SET_MAX)
 
 obj-m += ip_set.o ipt_set.o ipt_SET.o
 obj-m += ip_set_ipmap.o ip_set_macipmap.o ip_set_portmap.o
diff --git a/kernel/Kconfig.ipset b/kernel/Kconfig.ipset
index 8b27517..230eb01 100644
--- a/kernel/Kconfig.ipset
+++ b/kernel/Kconfig.ipset
@@ -20,17 +20,6 @@ config IP_NF_SET_MAX
 	  The value can be overriden by the 'max_sets' module
 	  parameter of the 'ip_set' module.
 
-config IP_NF_SET_HASHSIZE
-	int "Hash size for bindings of IP sets"
-	default 1024
-	depends on IP_NF_SET
-	help
-	  You can define here default value of the hash size for
-	  bindings of IP sets.
-
-	  The value can be overriden by the 'hash_size' module
-	  parameter of the 'ip_set' module.
-
 config IP_NF_SET_IPMAP
 	tristate "ipmap set support"
 	depends on IP_NF_SET
diff --git a/kernel/include/linux/netfilter_ipv4/ip_set.h b/kernel/include/linux/netfilter_ipv4/ip_set.h
index ec3e59f..e50c401 100644
--- a/kernel/include/linux/netfilter_ipv4/ip_set.h
+++ b/kernel/include/linux/netfilter_ipv4/ip_set.h
@@ -40,7 +40,7 @@
 /* 
  * Used so that the kernel module and ipset-binary can match their versions 
  */
-#define IP_SET_PROTOCOL_VERSION 2
+#define IP_SET_PROTOCOL_VERSION 3
 
 #define IP_SET_MAXNAMELEN 32	/* set names and set typenames */
 
@@ -71,7 +71,7 @@ typedef uint16_t ip_set_id_t;
 #define IP_SET_INVALID_ID	65535
 
 /* How deep we follow bindings */
-#define IP_SET_MAX_BINDINGS	6
+#define IP_SET_MAX_BINDINGS    6
 
 /*
  * Option flags for kernel operations (ipt_set_info)
@@ -99,7 +99,7 @@ typedef uint16_t ip_set_id_t;
  *
  * Operation ids:
  *	  0-99:	 commands with version checking
- *	100-199: add/del/test/bind/unbind
+ *	100-199: add/del/test
  *	200-299: list, save, restore
  */
 
@@ -156,14 +156,14 @@ struct ip_set_req_version {
 };
 
 /* Double shots operations: 
- * add, del, test, bind and unbind.
+ * add, del and test.
  *
  * First we query the kernel to get the index and type of the target set,
  * then issue the command. Validity of IP is checked in kernel in order
  * to minimalize sockopt operations.
  */
 
-/* Get minimal set data for add/del/test/bind/unbind IP */
+/* Get minimal set data for add/del/test IP */
 #define IP_SET_OP_ADT_GET	0x00000010	/* Get set and type */
 struct ip_set_req_adt_get {
 	unsigned op;
@@ -189,26 +189,12 @@ struct ip_set_req_adt {
 #define IP_SET_OP_TEST_IP	0x00000103	/* Test an IP in a set */
 /* Uses ip_set_req_adt, with type specific addage */
 
-#define IP_SET_OP_BIND_SET	0x00000104	/* Bind an IP to a set */
-/* Uses ip_set_req_bind, with type specific addage */
-struct ip_set_req_bind {
-	IP_SET_REQ_BYINDEX;
-	char binding[IP_SET_MAXNAMELEN];
-};
-
-#define IP_SET_OP_UNBIND_SET	0x00000105	/* Unbind an IP from a set */
-/* Uses ip_set_req_bind, with type speficic addage 
- * index = 0 means unbinding for all sets */
-
-#define IP_SET_OP_TEST_BIND_SET	0x00000106	/* Test binding an IP to a set */
-/* Uses ip_set_req_bind, with type specific addage */
-
 /* Multiple shots operations: list, save, restore.
  *
  * - check kernel version and query the max number of sets
  * - get the basic information on all sets
  *   and size required for the next step
- * - get actual set data: header, data, bindings
+ * - get actual set data: header, data
  */
 
 /* Get max_sets and the index of a queried set
@@ -228,7 +214,7 @@ struct ip_set_req_max_sets {
 struct ip_set_req_setnames {
 	unsigned op;
 	ip_set_id_t index;		/* set to list/save */
-	size_t size;			/* size to get setdata/bindings */
+	size_t size;			/* size to get setdata */
 	/* followed by sets number of struct ip_set_name_list */
 };
 
@@ -248,16 +234,9 @@ struct ip_set_req_list {
 
 struct ip_set_list {
 	ip_set_id_t index;
-	ip_set_id_t binding;
 	u_int32_t ref;
 	size_t header_size;	/* Set header data of header_size */
 	size_t members_size;	/* Set members data of members_size */
-	size_t bindings_size;	/* Set bindings data of bindings_size */
-};
-
-struct ip_set_hash_list {
-	ip_set_ip_t ip;
-	ip_set_id_t binding;
 };
 
 /* The save operation */
@@ -268,18 +247,10 @@ struct ip_set_hash_list {
  */
 struct ip_set_save {
 	ip_set_id_t index;
-	ip_set_id_t binding;
 	size_t header_size;	/* Set header data of header_size */
 	size_t members_size;	/* Set members data of members_size */
 };
 
-/* At restoring, ip == 0 means default binding for the given set: */
-struct ip_set_hash_save {
-	ip_set_ip_t ip;
-	ip_set_id_t id;
-	ip_set_id_t binding;
-};
-
 /* The restore operation */
 #define IP_SET_OP_RESTORE	0x00000205
 /* Uses ip_set_req_setnames followed by ip_set_restore structures
@@ -471,20 +442,11 @@ struct ip_set {
 	char name[IP_SET_MAXNAMELEN];	/* the name of the set */
 	rwlock_t lock;			/* lock for concurrency control */
 	ip_set_id_t id;			/* set id for swapping */
-	ip_set_id_t binding;		/* default binding for the set */
 	atomic_t ref;			/* in kernel and in hash references */
 	struct ip_set_type *type; 	/* the set types */
 	void *data;			/* pooltype specific data */
 };
 
-/* Structure to bind set elements to sets */
-struct ip_set_hash {
-	struct list_head list;		/* list of clashing entries in hash */
-	ip_set_ip_t ip;			/* ip from set */
-	ip_set_id_t id;			/* set id */
-	ip_set_id_t binding;		/* set we bind the element to */
-};
-
 /* register and unregister set references */
 extern ip_set_id_t ip_set_get_byname(const char name[IP_SET_MAXNAMELEN]);
 extern ip_set_id_t ip_set_get_byindex(ip_set_id_t index);
diff --git a/kernel/ip_set.c b/kernel/ip_set.c
index f60a63e..1df5417 100644
--- a/kernel/ip_set.c
+++ b/kernel/ip_set.c
@@ -41,9 +41,6 @@ static struct ip_set **ip_set_list;		/* all individual sets */
 static DEFINE_RWLOCK(ip_set_lock);		/* protects the lists and the hash */
 static DECLARE_MUTEX(ip_set_app_mutex);		/* serializes user access */
 static ip_set_id_t ip_set_max = CONFIG_IP_NF_SET_MAX;
-static ip_set_id_t ip_set_bindings_hash_size =  CONFIG_IP_NF_SET_HASHSIZE;
-static struct list_head *ip_set_hash;		/* hash of bindings */
-static unsigned int ip_set_hash_random;		/* random seed */
 
 #define SETNAME_EQ(a,b)		(strncmp(a,b,IP_SET_MAXNAMELEN) == 0)
 
@@ -51,7 +48,7 @@ static unsigned int ip_set_hash_random;		/* random seed */
  * Sets are identified either by the index in ip_set_list or by id.
  * The id never changes and is used to find a key in the hash.
  * The index may change by swapping and used at all other places
- * (set/SET netfilter modules, binding value, etc.)
+ * (set/SET netfilter modules, etc.)
  *
  * Userspace requests are serialized by ip_set_mutex and sets can
  * be deleted only from userspace. Therefore ip_set_list locking
@@ -73,143 +70,8 @@ __ip_set_put(ip_set_id_t index)
 	atomic_dec(&ip_set_list[index]->ref);
 }
 
-/*
- * Binding routines
- */
-
-static inline struct ip_set_hash *
-__ip_set_find(u_int32_t key, ip_set_id_t id, ip_set_ip_t ip)
-{
-	struct ip_set_hash *set_hash;
-
-	list_for_each_entry(set_hash, &ip_set_hash[key], list)
-		if (set_hash->id == id && set_hash->ip == ip)
-			return set_hash;
-			
-	return NULL;
-}
-
-static ip_set_id_t
-ip_set_find_in_hash(ip_set_id_t id, ip_set_ip_t ip)
-{
-	u_int32_t key = jhash_2words(id, ip, ip_set_hash_random)
-				% ip_set_bindings_hash_size;
-	struct ip_set_hash *set_hash;
-
-	ASSERT_READ_LOCK(&ip_set_lock);
-	IP_SET_ASSERT(ip_set_list[id]);
-	DP("set: %s, ip: %u.%u.%u.%u", ip_set_list[id]->name, HIPQUAD(ip));	
-	
-	set_hash = __ip_set_find(key, id, ip);
-	
-	DP("set: %s, ip: %u.%u.%u.%u, binding: %s", ip_set_list[id]->name,
-	   HIPQUAD(ip),
-	   set_hash != NULL ? ip_set_list[set_hash->binding]->name : "");
-
-	return (set_hash != NULL ? set_hash->binding : IP_SET_INVALID_ID);
-}
-
-static inline void
-__set_hash_del(struct ip_set_hash *set_hash)
-{
-	ASSERT_WRITE_LOCK(&ip_set_lock);
-	IP_SET_ASSERT(ip_set_list[set_hash->binding]);	
-
-	__ip_set_put(set_hash->binding);
-	list_del(&set_hash->list);
-	kfree(set_hash);
-}
-
-static int
-ip_set_hash_del(ip_set_id_t id, ip_set_ip_t ip)
-{
-	u_int32_t key = jhash_2words(id, ip, ip_set_hash_random)
-				% ip_set_bindings_hash_size;
-	struct ip_set_hash *set_hash;
-	
-	IP_SET_ASSERT(ip_set_list[id]);
-	DP("set: %s, ip: %u.%u.%u.%u", ip_set_list[id]->name, HIPQUAD(ip));	
-	write_lock_bh(&ip_set_lock);
-	set_hash = __ip_set_find(key, id, ip);
-	DP("set: %s, ip: %u.%u.%u.%u, binding: %s", ip_set_list[id]->name,
-	   HIPQUAD(ip),
-	   set_hash != NULL ? ip_set_list[set_hash->binding]->name : "");
-
-	if (set_hash != NULL)
-		__set_hash_del(set_hash);
- 	write_unlock_bh(&ip_set_lock);
-	return 0;
-}
-
-static int
-ip_set_hash_add(ip_set_id_t id, ip_set_ip_t ip, ip_set_id_t binding)
-{
-	u_int32_t key = jhash_2words(id, ip, ip_set_hash_random)
-				% ip_set_bindings_hash_size;
-	struct ip_set_hash *set_hash;
-	int ret = 0;
-	
-	IP_SET_ASSERT(ip_set_list[id]);
-	IP_SET_ASSERT(ip_set_list[binding]);
-	DP("set: %s, ip: %u.%u.%u.%u, binding: %s", ip_set_list[id]->name,
-	   HIPQUAD(ip), ip_set_list[binding]->name);
-	write_lock_bh(&ip_set_lock);
-	set_hash = __ip_set_find(key, id, ip);
-	if (!set_hash) {
-		set_hash = kmalloc(sizeof(struct ip_set_hash), GFP_ATOMIC);
-		if (!set_hash) {
-			ret = -ENOMEM;
-			goto unlock;
-		}
-		INIT_LIST_HEAD(&set_hash->list);
-		set_hash->id = id;
-		set_hash->ip = ip;
-		list_add(&set_hash->list, &ip_set_hash[key]);
-	} else {
-		IP_SET_ASSERT(ip_set_list[set_hash->binding]);	
-		DP("overwrite binding: %s",
-		   ip_set_list[set_hash->binding]->name);
-		__ip_set_put(set_hash->binding);
-	}
-	set_hash->binding = binding;
-	__ip_set_get(set_hash->binding);
-	DP("stored: key %u, id %u (%s), ip %u.%u.%u.%u, binding %u (%s)",
-	   key, id, ip_set_list[id]->name,
-	   HIPQUAD(ip), binding, ip_set_list[binding]->name);
-    unlock:
-	write_unlock_bh(&ip_set_lock);
-	return ret;
-}
-
-#define FOREACH_HASH_DO(fn, args...) 						\
-({										\
-	ip_set_id_t __key;							\
-	struct ip_set_hash *__set_hash;						\
-										\
-	for (__key = 0; __key < ip_set_bindings_hash_size; __key++) {		\
-		list_for_each_entry(__set_hash, &ip_set_hash[__key], list)	\
-			fn(__set_hash , ## args);				\
-	}									\
-})
-
-#define FOREACH_HASH_RW_DO(fn, args...) 						\
-({										\
-	ip_set_id_t __key;							\
-	struct ip_set_hash *__set_hash, *__n;					\
-										\
-	ASSERT_WRITE_LOCK(&ip_set_lock);					\
-	for (__key = 0; __key < ip_set_bindings_hash_size; __key++) {		\
-		list_for_each_entry_safe(__set_hash, __n, &ip_set_hash[__key], list)\
-			fn(__set_hash , ## args);				\
-	}									\
-})
-
 /* Add, del and test set entries from kernel */
 
-#define follow_bindings(index, set, ip)					\
-((index = ip_set_find_in_hash((set)->id, ip)) != IP_SET_INVALID_ID	\
- || (index = (set)->binding) != IP_SET_INVALID_ID)
-
 int
 ip_set_testip_kernel(ip_set_id_t index,
 		     const struct sk_buff *skb,
@@ -231,8 +93,7 @@ ip_set_testip_kernel(ip_set_id_t index,
 		read_unlock_bh(&set->lock);
 		i += !!(set->type->features & IPSET_DATA_DOUBLE);
 	} while (res > 0
-		 && flags[i]
-		 && follow_bindings(index, set, ip));
+		 && flags[i]);
 	read_unlock_bh(&ip_set_lock);
 
 	return (res < 0 ? 0 : res);
@@ -260,8 +121,7 @@ ip_set_addip_kernel(ip_set_id_t index,
 		write_unlock_bh(&set->lock);
 		i += !!(set->type->features & IPSET_DATA_DOUBLE);
 	} while ((res == 0 || res == -EEXIST)
-		 && flags[i]
-		 && follow_bindings(index, set, ip));
+		 && flags[i]);
 	read_unlock_bh(&ip_set_lock);
 
 	if (res == -EAGAIN
@@ -293,8 +153,7 @@ ip_set_delip_kernel(ip_set_id_t index,
 		write_unlock_bh(&set->lock);
 		i += !!(set->type->features & IPSET_DATA_DOUBLE);
 	} while ((res == 0 || res == -EEXIST)
-		 && flags[i]
-		 && follow_bindings(index, set, ip));
+		 && flags[i]);
 	read_unlock_bh(&ip_set_lock);
 	
 	return res;
@@ -487,7 +346,7 @@ ip_set_find_byindex(ip_set_id_t index)
 }
 
 /*
- * Add, del, test, bind and unbind
+ * Add, del and test
  */
 
 static inline int
@@ -598,63 +457,6 @@ ip_set_testip(ip_set_id_t index,
 	return (res > 0 ? -EEXIST : res);
 }
 
-static int
-ip_set_bindip(ip_set_id_t index,
-	      const void *data,
-	      size_t size)
-{
-	struct ip_set *set = ip_set_list[index];
-	const struct ip_set_req_bind *req_bind;
-	ip_set_id_t binding;
-	ip_set_ip_t ip;
-	int res;
-
-	IP_SET_ASSERT(set);
-	if (size < sizeof(struct ip_set_req_bind))
-		return -EINVAL;
-		
-	req_bind = data;
-
-	if (SETNAME_EQ(req_bind->binding, IPSET_TOKEN_DEFAULT)) {
-		/* Default binding of a set */
-		const char *binding_name;
-		
-		if (size != sizeof(struct ip_set_req_bind) + IP_SET_MAXNAMELEN)
-			return -EINVAL;
-
-		binding_name = data + sizeof(struct ip_set_req_bind);
-
-		binding = ip_set_find_byname(binding_name);
-		if (binding == IP_SET_INVALID_ID)
-			return -ENOENT;
-
-		write_lock_bh(&ip_set_lock);
-		/* Sets as binding values are referenced */
-		if (set->binding != IP_SET_INVALID_ID)
-			__ip_set_put(set->binding);
-		set->binding = binding;
-		__ip_set_get(set->binding);
-		write_unlock_bh(&ip_set_lock);
-
-		return 0;
-	}
-	binding = ip_set_find_byname(req_bind->binding);
-	if (binding == IP_SET_INVALID_ID)
-		return -ENOENT;
-
-	res = __ip_set_testip(set,
-			      data + sizeof(struct ip_set_req_bind),
-			      size - sizeof(struct ip_set_req_bind),
-			      &ip);
-	DP("set %s, ip: %u.%u.%u.%u, binding %s",
-	   set->name, HIPQUAD(ip), ip_set_list[binding]->name);
-	
-	if (res >= 0)
-		res = ip_set_hash_add(set->id, ip, binding);
-
-	return res;
-}
-
 #define FOREACH_SET_DO(fn, args...) 				\
 ({								\
 	ip_set_id_t __i;					\
@@ -667,149 +469,6 @@ ip_set_bindip(ip_set_id_t index,
 	}							\
 })
 
-static inline void
-__set_hash_del_byid(struct ip_set_hash *set_hash, ip_set_id_t id)
-{
-	if (set_hash->id == id)
-		__set_hash_del(set_hash);
-}
-
-static inline void
-__unbind_default(struct ip_set *set)
-{
-	if (set->binding != IP_SET_INVALID_ID) {
-		/* Sets as binding values are referenced */
-		__ip_set_put(set->binding);
-		set->binding = IP_SET_INVALID_ID;
-	}
-}
-
-static int
-ip_set_unbindip(ip_set_id_t index,
-	        const void *data,
-	        size_t size)
-{
-	struct ip_set *set;
-	const struct ip_set_req_bind *req_bind;
-	ip_set_ip_t ip;
-	int res;
-
-	DP("");
-	if (size < sizeof(struct ip_set_req_bind))
-		return -EINVAL;
-		
-	req_bind = data;
-	
-	DP("%u %s", index, req_bind->binding);
-	if (index == IP_SET_INVALID_ID) {
-		/* unbind :all: */
-		if (SETNAME_EQ(req_bind->binding, IPSET_TOKEN_DEFAULT)) {
-			/* Default binding of sets */
-			write_lock_bh(&ip_set_lock);
-			FOREACH_SET_DO(__unbind_default);
-			write_unlock_bh(&ip_set_lock);
-			return 0;
-		} else if (SETNAME_EQ(req_bind->binding, IPSET_TOKEN_ALL)) {
-			/* Flush all bindings of all sets*/
-			write_lock_bh(&ip_set_lock);
-			FOREACH_HASH_RW_DO(__set_hash_del);
-			write_unlock_bh(&ip_set_lock);
-			return 0;
-		}
-		DP("unreachable reached!");
-		return -EINVAL;
-	}
-	
-	set = ip_set_list[index];
-	IP_SET_ASSERT(set);
-	if (SETNAME_EQ(req_bind->binding, IPSET_TOKEN_DEFAULT)) {
-		/* Default binding of set */
-		ip_set_id_t binding = ip_set_find_byindex(set->binding);
-
-		if (binding == IP_SET_INVALID_ID)
-			return -ENOENT;
-			
-		write_lock_bh(&ip_set_lock);
-		/* Sets in hash values are referenced */
-		__ip_set_put(set->binding);
-		set->binding = IP_SET_INVALID_ID;
-		write_unlock_bh(&ip_set_lock);
-
-		return 0;
-	} else if (SETNAME_EQ(req_bind->binding, IPSET_TOKEN_ALL)) {
-		/* Flush all bindings */
-
-		write_lock_bh(&ip_set_lock);
-		FOREACH_HASH_RW_DO(__set_hash_del_byid, set->id);
-		write_unlock_bh(&ip_set_lock);
-		return 0;
-	}
-	
-	res = __ip_set_testip(set,
-			      data + sizeof(struct ip_set_req_bind),
-			      size - sizeof(struct ip_set_req_bind),
-			      &ip);
-
-	DP("set %s, ip: %u.%u.%u.%u", set->name, HIPQUAD(ip));
-	if (res >= 0)
-		res = ip_set_hash_del(set->id, ip);
-
-	return res;
-}
-
-static int
-ip_set_testbind(ip_set_id_t index,
-	        const void *data,
-	        size_t size)
-{
-	struct ip_set *set = ip_set_list[index];
-	const struct ip_set_req_bind *req_bind;
-	ip_set_id_t binding;
-	ip_set_ip_t ip;
-	int res;
-
-	IP_SET_ASSERT(set);
-	if (size < sizeof(struct ip_set_req_bind))
-		return -EINVAL;
-		
-	req_bind = data;
-
-	if (SETNAME_EQ(req_bind->binding, IPSET_TOKEN_DEFAULT)) {
-		/* Default binding of set */
-		const char *binding_name;
-		
-		if (size != sizeof(struct ip_set_req_bind) + IP_SET_MAXNAMELEN)
-			return -EINVAL;
-
-		binding_name = data + sizeof(struct ip_set_req_bind);
-
-		binding = ip_set_find_byname(binding_name);
-		if (binding == IP_SET_INVALID_ID)
-			return -ENOENT;
-		
-		res = (set->binding == binding) ? -EEXIST : 0;
-
-		return res;
-	}
-	binding = ip_set_find_byname(req_bind->binding);
-	if (binding == IP_SET_INVALID_ID)
-		return -ENOENT;
-		
-	
-	res = __ip_set_testip(set,
-			      data + sizeof(struct ip_set_req_bind),
-			      size - sizeof(struct ip_set_req_bind),
-			      &ip);
-	DP("set %s, ip: %u.%u.%u.%u, binding %s",
-	   set->name, HIPQUAD(ip), ip_set_list[binding]->name);
-	
-	if (res >= 0)
-		res = (ip_set_find_in_hash(set->id, ip) == binding)
-			? -EEXIST : 0;
-
-	return res;
-}
-
 static struct ip_set_type *
 find_set_type_rlock(const char *typename)
 {
@@ -879,7 +538,6 @@ ip_set_create(const char *name,
 		return -ENOMEM;
 	set->lock = RW_LOCK_UNLOCKED;
 	strncpy(set->name, name, IP_SET_MAXNAMELEN);
-	set->binding = IP_SET_INVALID_ID;
 	atomic_set(&set->ref, 0);
 
 	/*
@@ -978,9 +636,6 @@ ip_set_destroy_set(ip_set_id_t index)
 	IP_SET_ASSERT(set);
 	DP("set: %s",  set->name);
 	write_lock_bh(&ip_set_lock);
-	FOREACH_HASH_RW_DO(__set_hash_del_byid, set->id);
-	if (set->binding != IP_SET_INVALID_ID)
-		__ip_set_put(set->binding);
 	ip_set_list[index] = NULL;
 	write_unlock_bh(&ip_set_lock);
 
@@ -1107,35 +762,6 @@ ip_set_swap(ip_set_id_t from_index, ip_set_id_t to_index)
  * List set data
  */
 
-static inline void
-__set_hash_bindings_size_list(struct ip_set_hash *set_hash,
-			      ip_set_id_t id, size_t *size)
-{
-	if (set_hash->id == id)
-		*size += sizeof(struct ip_set_hash_list);
-}
-
-static inline void
-__set_hash_bindings_size_save(struct ip_set_hash *set_hash,
-			      ip_set_id_t id, size_t *size)
-{
-	if (set_hash->id == id)
-		*size += sizeof(struct ip_set_hash_save);
-}
-
-static inline void
-__set_hash_bindings(struct ip_set_hash *set_hash,
-		    ip_set_id_t id, void *data, int *used)
-{
-	if (set_hash->id == id) {
-		struct ip_set_hash_list *hash_list = data + *used;
-
-		hash_list->ip = set_hash->ip;
-		hash_list->binding = set_hash->binding;
-		*used += sizeof(struct ip_set_hash_list);
-	}
-}
-
 static int ip_set_list_set(ip_set_id_t index,
 			   void *data,
 			   int *used,
@@ -1162,7 +788,6 @@ static int ip_set_list_set(ip_set_id_t index,
 
 	/* Fill in the header */
 	set_list->index = index;
-	set_list->binding = set->binding;
 	set_list->ref = atomic_read(&set->ref);
 
 	/* Fill in set spefific header data */
@@ -1179,18 +804,6 @@ static int ip_set_list_set(ip_set_id_t index,
 	*used += set_list->members_size;
 	read_unlock_bh(&set->lock);
 
-	/* Bindings */
-
-	/* Get and ensure set specific bindings size */
-	set_list->bindings_size = 0;
-	FOREACH_HASH_DO(__set_hash_bindings_size_list,
-			set->id, &set_list->bindings_size);
-	if (*used + set_list->bindings_size > len)
-		goto not_enough_mem;
-
-	/* Fill in set spefific bindings data */
-	FOREACH_HASH_DO(__set_hash_bindings, set->id, data, used);
-	
 	return 0;
 
     unlock_set:
@@ -1231,7 +844,6 @@ static int ip_set_save_set(ip_set_id_t index,
 
 	/* Fill in the header */
 	set_save->index = index;
-	set_save->binding = set->binding;
 
 	/* Fill in set spefific header data */
 	set->type->list_header(set, data + *used);
@@ -1259,59 +871,6 @@ static int ip_set_save_set(ip_set_id_t index,
 	return -EAGAIN;
 }
 
-static inline void
-__set_hash_save_bindings(struct ip_set_hash *set_hash,
-			 ip_set_id_t id,
-			 void *data,
-			 int *used,
-			 int len,
-			 int *res)
-{
-	if (*res == 0
-	    && (id == IP_SET_INVALID_ID || set_hash->id == id)) {
-		struct ip_set_hash_save *hash_save = data + *used;
-		/* Ensure bindings size */
-		if (*used + sizeof(struct ip_set_hash_save) > len) {
-			*res = -ENOMEM;
-			return;
-		}
-		hash_save->id = set_hash->id;
-		hash_save->ip = set_hash->ip;
-		hash_save->binding = set_hash->binding;
-		*used += sizeof(struct ip_set_hash_save);
-	}
-}
-
-static int ip_set_save_bindings(ip_set_id_t index,
-			   	void *data,
-			   	int *used,
-			   	int len)
-{
-	int res = 0;
-	struct ip_set_save *set_save;
-
-	DP("used %u, len %u", *used, len);
-	/* Get and ensure header size */
-	if (*used + sizeof(struct ip_set_save) > len)
-		return -ENOMEM;
-
-	/* Marker */
-	set_save = data + *used;
-	set_save->index = IP_SET_INVALID_ID;
-	set_save->header_size = 0;
-	set_save->members_size = 0;
-	*used += sizeof(struct ip_set_save);
-
-	DP("marker added used %u, len %u", *used, len);
-	/* Fill in bindings data */
-	if (index != IP_SET_INVALID_ID)
-		/* Sets are identified by id in hash */
-		index = ip_set_list[index]->id;
-	FOREACH_HASH_DO(__set_hash_save_bindings, index, data, used, len, &res);
-
-	return res;	
-}
-
 /*
  * Restore sets
  */
@@ -1321,7 +880,6 @@ static int ip_set_restore(void *data,
 	int res = 0;
 	int line = 0, used = 0, members_size;
 	struct ip_set *set;
-	struct ip_set_hash_save *hash_save;
 	struct ip_set_restore *set_restore;
 	ip_set_id_t index;
 
@@ -1345,7 +903,7 @@ static int ip_set_restore(void *data,
 		/* Check marker */
 		if (set_restore->index == IP_SET_INVALID_ID) {
 			line--;
-			goto bindings;
+			goto done;
 		}
 		
 		/* Try to create the set */
@@ -1388,45 +946,7 @@ static int ip_set_restore(void *data,
 		used += set_restore->members_size;		
 	}
 	
-   bindings:
-   	/* Loop to restore bindings */
-   	while (used < len) {
-		line++;
-
-		DP("restore binding, line %u", line);		
-		/* Get and ensure size */
-		if (used + sizeof(struct ip_set_hash_save) > len)
-			return line;
-		hash_save = data + used;
-		used += sizeof(struct ip_set_hash_save);
-		
-		/* hash_save->id is used to store the index */
-		index = ip_set_find_byindex(hash_save->id);
-		DP("restore binding index %u, id %u, %u -> %u",
-		   index, hash_save->id, hash_save->ip, hash_save->binding);		
-		if (index != hash_save->id)
-			return line;
-		if (ip_set_find_byindex(hash_save->binding) == IP_SET_INVALID_ID) {
-			DP("corrupt binding set index %u", hash_save->binding);
-			return line;
-		}
-		set = ip_set_list[hash_save->id];
-		/* Null valued IP means default binding */
-		if (hash_save->ip)
-			res = ip_set_hash_add(set->id,
-					      hash_save->ip,
-					      hash_save->binding);
-		else {
-			IP_SET_ASSERT(set->binding == IP_SET_INVALID_ID);
-			write_lock_bh(&ip_set_lock);
-			set->binding = hash_save->binding;
-			__ip_set_get(set->binding);
-			write_unlock_bh(&ip_set_lock);
-			DP("default binding: %u", set->binding);
-		}
-		if (res != 0)
-			return line;
-   	}
+   done:
    	if (used != len)
    		return line;
    	
@@ -1448,7 +968,6 @@ ip_set_sockfn_set(struct sock *sk, int optval, void *user, unsigned int len)
 			  const void *data, size_t size);
 	} adtfn_table[] =
 	{ { ip_set_addip }, { ip_set_delip }, { ip_set_testip},
-	  { ip_set_bindip}, { ip_set_unbindip }, { ip_set_testbind },
 	};
 
 	DP("optval=%d, user=%p, len=%d", optval, user, len);
@@ -1607,8 +1126,8 @@ ip_set_sockfn_set(struct sock *sk, int optval, void *user, unsigned int len)
 		break;	/* Set identified by id */
 	}
 	
-	/* There we may have add/del/test/bind/unbind/test_bind operations */
-	if (*op < IP_SET_OP_ADD_IP || *op > IP_SET_OP_TEST_BIND_SET) {
+	/* There we may have add/del/test operations */
+	if (*op < IP_SET_OP_ADD_IP || *op > IP_SET_OP_TEST_IP) {
 		res = -EBADMSG;
 		goto done;
 	}
@@ -1622,15 +1141,12 @@ ip_set_sockfn_set(struct sock *sk, int optval, void *user, unsigned int len)
 	}
 	req_adt = data;
 
-	/* -U :all: :all:|:default: uses IP_SET_INVALID_ID */
-	if (!(*op == IP_SET_OP_UNBIND_SET
-	      && req_adt->index == IP_SET_INVALID_ID)) {
-		index = ip_set_find_byindex(req_adt->index);
-		if (index == IP_SET_INVALID_ID) {
-			res = -ENOENT;
-			goto done;
-		}
+	index = ip_set_find_byindex(req_adt->index);
+	if (index == IP_SET_INVALID_ID) {
+		res = -ENOENT;
+		goto done;
 	}
+
 	res = adtfn(index, data, len);
 
     done:
@@ -1834,17 +1350,12 @@ ip_set_sockfn_get(struct sock *sk, int optval, void *user, int *len)
 				req_setnames->size += sizeof(struct ip_set_list)
 					+ set->type->header_size
 					+ set->type->list_members_size(set);
-				/* Sets are identified by id in the hash */
-				FOREACH_HASH_DO(__set_hash_bindings_size_list,
-						set->id, &req_setnames->size);
 				break;
 			}
 			case IP_SET_OP_SAVE_SIZE: {
 				req_setnames->size += sizeof(struct ip_set_save)
 					+ set->type->header_size
 					+ set->type->list_members_size(set);
-				FOREACH_HASH_DO(__set_hash_bindings_size_save,
-						set->id, &req_setnames->size);
 				break;
 			}
 			default:
@@ -1921,8 +1432,6 @@ ip_set_sockfn_get(struct sock *sk, int optval, void *user, int *len)
 			/* Save an individual set */
 			res = ip_set_save_set(index, data, &used, *len);
 		}
-		if (res == 0)
-			res = ip_set_save_bindings(index, data, &used, *len);
 			
 		if (res != 0)
 			goto done;
@@ -1990,12 +1499,10 @@ static struct nf_sockopt_ops so_set = {
 #endif
 };
 
-static int max_sets, hash_size;
+static int max_sets;
 
 module_param(max_sets, int, 0600);
 MODULE_PARM_DESC(max_sets, "maximal number of sets");
-module_param(hash_size, int, 0600);
-MODULE_PARM_DESC(hash_size, "hash size for bindings");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
 MODULE_DESCRIPTION("module implementing core IP set support");
@@ -2003,9 +1510,7 @@ MODULE_DESCRIPTION("module implementing core IP set support");
 static int __init ip_set_init(void)
 {
 	int res;
-	ip_set_id_t i;
 
-	get_random_bytes(&ip_set_hash_random, 4);
 	if (max_sets)
 		ip_set_max = max_sets;
 	ip_set_list = vmalloc(sizeof(struct ip_set *) * ip_set_max);
@@ -2014,16 +1519,6 @@ static int __init ip_set_init(void)
 		return -ENOMEM;
 	}
 	memset(ip_set_list, 0, sizeof(struct ip_set *) * ip_set_max);
-	if (hash_size)
-		ip_set_bindings_hash_size = hash_size;
-	ip_set_hash = vmalloc(sizeof(struct list_head) * ip_set_bindings_hash_size);
-	if (!ip_set_hash) {
-		printk(KERN_ERR "Unable to create ip_set_hash\n");
-		vfree(ip_set_list);
-		return -ENOMEM;
-	}
-	for (i = 0; i < ip_set_bindings_hash_size; i++)
-		INIT_LIST_HEAD(&ip_set_hash[i]);
 
 	INIT_LIST_HEAD(&set_type_list);
 
@@ -2031,7 +1526,6 @@ static int __init ip_set_init(void)
 	if (res != 0) {
 		ip_set_printk("SO_SET registry failed: %d", res);
 		vfree(ip_set_list);
-		vfree(ip_set_hash);
 		return res;
 	}
 	
@@ -2040,10 +1534,9 @@ static int __init ip_set_init(void)
 
 static void __exit ip_set_fini(void)
 {
-	/* There can't be any existing set or binding */
+	/* There can't be any existing set */
 	nf_unregister_sockopt(&so_set);
 	vfree(ip_set_list);
-	vfree(ip_set_hash);
 	DP("these are the famous last words");
 }
 

--=-yk3BhxNxLhrJWcTQCu4c--

