From: Enrique Perez-Terron <enrio@online.no>
Subject: New manpage for libipt_recent
Date: Fri, 15 Jul 2005 00:20:39 +0200 (CEST)
Message-ID: <5211541.1121379639205.JavaMail.adm-moff@moffice8.nsc.no>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_6787_7972157.1121379639198"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

------=_Part_6787_7972157.1121379639198
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

The file  trunk / iptables / extensions / libipt_recent.man says you can 
prefix inversion bangs to the options --seconds and --hit-count, but the code
in trunk / iptables / extensions / libipt_recent.c says

    case 204:
        info->seconds = atoi(optarg);
        break;

    case 205:
        info->hit_count = atoi(optarg);
        break;

i.e, there is no call to check_inverse() like there is for the options --rcheck, 
--update, --set, and --remove, like this:

        check_inverse(optarg, &invert, &optind, 0);
        info->check_set |= IPT_RECENT_REMOVE;
        if (invert) info->invert = 1;

I also think the manual page could be clearer with respect to what is negated.
Reading the code it appears that the list of ip addresses is changed or not in exactly the same way with or without the bang.  Only the return status is negated. I believe that affects how netfilter continues through its tables, taking the jump indicated in the rule, or not.

One exception though; "! --set" (whenever that may make sense) appears to reliably 
do nothing and return false. I think the bang here could just as well be un-documented.

I have written a new manpage, extending the current one quite much.
The current man-page looks like it is intended to be embedded in something, but I do not know what that is. I am therefore afraid that Somebody :) will have to edit it further to fit whatever framework it needs to fit.

Could you please look through it and tell me about any errors and misunderstandings?
I have not read the code _that_ extensively.

For your convenience I have attached both the diff -u and the resulting .man

Regards,
Enrique Perez-Terron

------=_Part_6787_7972157.1121379639198
Content-Type: application/octet-stream; name=diff-libipt_recent.man
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=diff-libipt_recent.man

--- old-libipt_recent.man	2005-07-14 23:37:00.000000000 +0200
+++ new-libipt_recent.man	2005-07-15 00:08:07.000000000 +0200
@@ -1,15 +1,49 @@
-Allows you to dynamically create a list of IP addresses and then match
+\" (C) Copyright 2005 Jonas Berlin, Enrique Perez-Terron, and possibly many others.
+\" This document will possibly be made available to the public under some
+\" Open-source or free-redistribution lisence. Please look for a released
+\" version of it, as this is a mere draft. The terms will likely be stated
+\" on the final versions. For the time being, all rights reserved.
+.TH Extensions IpTables
+.SH NAME
+recent \- maintain in-kernel lists of recent source or destination IP addreses
+.SH SYNOPSIS
+.LP
+.BI "-m recent [ --name " listname " ] { --set | [!] --remove } [ --rsource | --rdest ]"
+.LP
+.BI "-m recent [ --name " listname " ] [!] { --rcheck | --update }" 
+.BI "[ --seconds " seconds " ] [ --hitcount " hits " ] [ --rttl ] [--rsource | --rdest ]"
+.SH DESCRIPTION
+The \fBrecent\fP module is an extension module to the \fBiptables\fP command and 
+the \fBnetfilter\fP system in the \fBLinux\fP kernel, see \fIiptables\fP(8).
+.P
+It allows you to dynamically create a list of IP addresses and then match
 against that list in a few different ways.
-
+.P
 For example, you can create a `badguy' list out of people attempting
 to connect to port 139 on your firewall and then DROP all future
 packets from them without considering them.
+.P
+The exclamation mark can be used to invert the success or failure return status.
+It does not affect the posible changes to the lists.  For instance, "\fB! --update\fP"
+updates the list in question provided the address in question already exists in 
+the list. So does also the the \fB--update\fP command without the exclamation mark.
+The difference is that the rule is a match and the jump in the \fB-j\fP option to 
+\fBiptables\fP is taken if the address was not found in the list and therefore not 
+updated, if the exclamation sign is present, while the jump is taken in the 
+opposite cases if the exclamation mark is absent.
+.P
+If different rules save the same address in different lists, 
+each list has a separate list of timestamps. 
+If different rules save the same address or check for its presence in the same list, 
+they operate on the same list of timestamps. 
+
+.SH OPTIONS
 .TP
 .BI "--name " "name"
 Specify the list to use for the commands. If no name is given then 'DEFAULT'
 will be used.
 .TP
-[\fB!\fR] \fB--set\fR
+\fB--set\fR
 This will add the source address of the packet to the list. If the
 source address is already in the list, this will update the existing
 entry. This will always return success (or failure if `!' is passed
@@ -28,13 +62,13 @@
 if so that address will be removed from the list and the rule will
 return true. If the address is not found, false is returned.
 .TP
-[\fB!\fR] \fB--seconds \fIseconds\fR
+\fB--seconds \fIseconds\fR
 This option must be used in conjunction with one of \fB--rcheck\fR or
 \fB--update\fR. When used, this will narrow the match to only happen
 when the address is in the list and was seen within the last given
 number of seconds.
 .TP
-[\fB!\fR] \fB--hitcount \fIhits\fR
+\fB--hitcount \fIhits\fR
 This option must be used in conjunction with one of \fB--rcheck\fR or
 \fB--update\fR. When used, this will narrow the match to only happen
 when the address is in the list and packets had been received greater
@@ -50,21 +84,32 @@
 useful if you have problems with people faking their source address in
 order to DoS you via this module by disallowing others access to your
 site by sending bogus packets to you.
+.TP
+\fB--rdest\fR
+Match or save the destination address of the packet.
+.TP
+\fB--rsource\fR
+Match or save the source address of the packet. This is the default.
 .P
-Examples:
+.SH EXAMPLES:
 .IP
 # iptables -A FORWARD -m recent --name badguy --rcheck --seconds 60 -j DROP
-
+.br
 # iptables -A FORWARD -p tcp -i eth0 --dport 139 -m recent --name badguy --set -j DROP
 .P
-Official website (http://snowman.net/projects/ipt_recent/) also has
+In the the two rules above, only the last one will add addresses to the \fIbadguy\fP list.
+The first command will ensure that for the next minute, all IP packets from the same source, 
+irrespective of protocol or port, go to the bit bucket.
+.P
+The official website (http://snowman.net/projects/ipt_recent/) also has
 some examples of usage.
 
-/proc/net/ipt_recent/* are the current lists of addresses and information 
+.SH /PROC INTERFACE
+The files /proc/net/ipt_recent/* contain the current lists of addresses and information 
 about each entry of each list.
 
-Each file in /proc/net/ipt_recent/ can be read from to see the current list
-or written two using the following commands to modify the list:
+Each file in /proc/net/ipt_recent/ can be read in order to see the current list,
+or written to using the following commands to modify the list:
 .TP
 echo xx.xx.xx.xx > /proc/net/ipt_recent/DEFAULT
 to Add to the DEFAULT list
@@ -74,20 +119,46 @@
 .TP
 echo clear > /proc/net/ipt_recent/DEFAULT
 to empty the DEFAULT list.
+
+.SH MODULE PARAMETERS
+For each list and each address, the module keeps a timestamp for each of a 
+limited number of the last packets seen. 
+It does not make sense to specify 
+a hit-count larger than this limit 
+since there will never be more hits in the list than it can hold.
 .P
-The module itself accepts parameters, defaults shown:
+There is also a limit to the number of distinct IP addresses a list can hold.
+.P
+These limits can be controlled through the following module parameters:
 .TP
-.BI "ip_list_tot=" "100"
-Number of addresses remembered per table
+.BI ip_list_tot
+integer, default 100. Number of IPs to remember per list.
 .TP
-.BI "ip_pkt_list_tot=" "20"
-Number of packets per address remembered
+.BI ip_pkt_list_tot
+Integer, default 20. Number of packets per IP to remember.
 .TP
-.BI "ip_list_hash_size=" "0"
-Hash table size. 0 means to calculate it based on ip_list_tot, default: 512
+.BI ip_list_hash_size
+Integer, defaults to the smallest power of two not smaller than three times ip_list_tot.
+The size of the per-list hash table used to look up IPs.
 .TP
-.BI "ip_list_perms=" "0644"
-Permissions for /proc/net/ipt_recent/* files
+.BI ip_list_perms 
+Integer, default 0644 (octal). The permissions on /proc/net/ipt_recent/* files. (See below.)
 .TP
-.BI "debug=" "0"
-Set to 1 to get lots of debugging info
+.B debug
+Integer, default 1. This parameter can be deselected at compile time. 
+If available, it turns on extensive logging of internal events.
+
+.SH NOTES
+The module documented here is part of the \fBiptables\fP command, 
+which control the \fBnetfilter\fP network packet filtering in the 
+Linux kernel. This can be used to set up a firewall to protect a 
+computer from malicious intruders, among many other things.
+
+.SH SEE ALSO
+.IR iptables (8)
+.P
+http://snowman.net/projects/ipt_recent/
+.P
+http://www.netfilter.org/
+.P
+http://www.netfilter.org/documentation/HOWTO//netfilter-extensions-HOWTO.html

------=_Part_6787_7972157.1121379639198
Content-Type: application/octet-stream; name=new-libipt_recent.man
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=new-libipt_recent.man

\" (C) Copyright 2005 Jonas Berlin, Enrique Perez-Terron, and possibly many others.
\" This document will possibly be made available to the public under some
\" Open-source or free-redistribution lisence. Please look for a released
\" version of it, as this is a mere draft. The terms will likely be stated
\" on the final versions. For the time being, all rights reserved.
.TH Extensions IpTables
.SH NAME
recent \- maintain in-kernel lists of recent source or destination IP addreses
.SH SYNOPSIS
.LP
.BI "-m recent [ --name " listname " ] { --set | [!] --remove } [ --rsource | --rdest ]"
.LP
.BI "-m recent [ --name " listname " ] [!] { --rcheck | --update }" 
.BI "[ --seconds " seconds " ] [ --hitcount " hits " ] [ --rttl ] [--rsource | --rdest ]"
.SH DESCRIPTION
The \fBrecent\fP module is an extension module to the \fBiptables\fP command and 
the \fBnetfilter\fP system in the \fBLinux\fP kernel, see \fIiptables\fP(8).
.P
It allows you to dynamically create a list of IP addresses and then match
against that list in a few different ways.
.P
For example, you can create a `badguy' list out of people attempting
to connect to port 139 on your firewall and then DROP all future
packets from them without considering them.
.P
The exclamation mark can be used to invert the success or failure return status.
It does not affect the posible changes to the lists.  For instance, "\fB! --update\fP"
updates the list in question provided the address in question already exists in 
the list. So does also the the \fB--update\fP command without the exclamation mark.
The difference is that the rule is a match and the jump in the \fB-j\fP option to 
\fBiptables\fP is taken if the address was not found in the list and therefore not 
updated, if the exclamation sign is present, while the jump is taken in the 
opposite cases if the exclamation mark is absent.
.P
If different rules save the same address in different lists, 
each list has a separate list of timestamps. 
If different rules save the same address or check for its presence in the same list, 
they operate on the same list of timestamps. 

.SH OPTIONS
.TP
.BI "--name " "name"
Specify the list to use for the commands. If no name is given then 'DEFAULT'
will be used.
.TP
\fB--set\fR
This will add the source address of the packet to the list. If the
source address is already in the list, this will update the existing
entry. This will always return success (or failure if `!' is passed
in).
.TP
[\fB!\fR] \fB--rcheck\fR
Check if the source address of the packet is currently in
the list.
.TP
[\fB!\fR] \fB--update\fR
Like \fB--rcheck\fR, except it will update the "last seen" timestamp if it
matches.
.TP
[\fB!\fR] \fB--remove\fR
Check if the source address of the packet is currently in the list and
if so that address will be removed from the list and the rule will
return true. If the address is not found, false is returned.
.TP
\fB--seconds \fIseconds\fR
This option must be used in conjunction with one of \fB--rcheck\fR or
\fB--update\fR. When used, this will narrow the match to only happen
when the address is in the list and was seen within the last given
number of seconds.
.TP
\fB--hitcount \fIhits\fR
This option must be used in conjunction with one of \fB--rcheck\fR or
\fB--update\fR. When used, this will narrow the match to only happen
when the address is in the list and packets had been received greater
than or equal to the given value. This option may be used along with
\fB--seconds\fR to create an even narrower match requiring a certain
number of hits within a specific time frame.
.TP
\fB--rttl\fR
This option must be used in conjunction with one of \fB--rcheck\fR or
\fB--update\fR. When used, this will narrow the match to only happen
when the address is in the list and the TTL of the current packet
matches that of the packet which hit the \fB--set\fR rule. This may be
useful if you have problems with people faking their source address in
order to DoS you via this module by disallowing others access to your
site by sending bogus packets to you.
.TP
\fB--rdest\fR
Match or save the destination address of the packet.
.TP
\fB--rsource\fR
Match or save the source address of the packet. This is the default.
.P
.SH EXAMPLES:
.IP
# iptables -A FORWARD -m recent --name badguy --rcheck --seconds 60 -j DROP
.br
# iptables -A FORWARD -p tcp -i eth0 --dport 139 -m recent --name badguy --set -j DROP
.P
In the the two rules above, only the last one will add addresses to the \fIbadguy\fP list.
The first command will ensure that for the next minute, all IP packets from the same source, 
irrespective of protocol or port, go to the bit bucket.
.P
The official website (http://snowman.net/projects/ipt_recent/) also has
some examples of usage.

.SH /PROC INTERFACE
The files /proc/net/ipt_recent/* contain the current lists of addresses and information 
about each entry of each list.

Each file in /proc/net/ipt_recent/ can be read in order to see the current list,
or written to using the following commands to modify the list:
.TP
echo xx.xx.xx.xx > /proc/net/ipt_recent/DEFAULT
to Add to the DEFAULT list
.TP
echo -xx.xx.xx.xx > /proc/net/ipt_recent/DEFAULT
to Remove from the DEFAULT list
.TP
echo clear > /proc/net/ipt_recent/DEFAULT
to empty the DEFAULT list.

.SH MODULE PARAMETERS
For each list and each address, the module keeps a timestamp for each of a 
limited number of the last packets seen. 
It does not make sense to specify 
a hit-count larger than this limit 
since there will never be more hits in the list than it can hold.
.P
There is also a limit to the number of distinct IP addresses a list can hold.
.P
These limits can be controlled through the following module parameters:
.TP
.BI ip_list_tot
integer, default 100. Number of IPs to remember per list.
.TP
.BI ip_pkt_list_tot
Integer, default 20. Number of packets per IP to remember.
.TP
.BI ip_list_hash_size
Integer, defaults to the smallest power of two not smaller than three times ip_list_tot.
The size of the per-list hash table used to look up IPs.
.TP
.BI ip_list_perms 
Integer, default 0644 (octal). The permissions on /proc/net/ipt_recent/* files. (See below.)
.TP
.B debug
Integer, default 1. This parameter can be deselected at compile time. 
If available, it turns on extensive logging of internal events.

.SH NOTES
The module documented here is part of the \fBiptables\fP command, 
which control the \fBnetfilter\fP network packet filtering in the 
Linux kernel. This can be used to set up a firewall to protect a 
computer from malicious intruders, among many other things.

.SH SEE ALSO
.IR iptables (8)
.P
http://snowman.net/projects/ipt_recent/
.P
http://www.netfilter.org/
.P
http://www.netfilter.org/documentation/HOWTO//netfilter-extensions-HOWTO.html

------=_Part_6787_7972157.1121379639198--
