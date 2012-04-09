From: Gregory Nietsky <gregory@distrotech.co.za>
Subject: Proposed new target SESSION allow for session/accounting management
 [RADIUS/802.1x]
Date: Mon, 09 Apr 2012 14:14:49 +0200
Message-ID: <4F82D2B9.9050709@distrotech.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter Dev List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp01.isdsl.net ([196.26.208.190]:59840 "EHLO smtp01.isdsl.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943Ab2DIMrF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Apr 2012 08:47:05 -0400
Received: from 196-209-227-124.dynamic.isadsl.co.za ([196.209.227.124]:56058)
	by smtp01.isdsl.net with esmtp (Exim 4.77 #0)
	(envelope-from <gregory@distrotech.co.za>)
	id 1SHDW2-000Kqu-Hm
	for <netfilter-devel@vger.kernel.org>; Mon, 09 Apr 2012 14:16:16 +0200
Received: from [10.0.0.4] (41-132-209-253.dsl.mweb.co.za [41.132.209.253])
	(authenticated bits=0)
	by 196-209-227-124.dynamic.isadsl.co.za (8.14.3/8.14.3) with ESMTP id q39CEs5m013248
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Mon, 9 Apr 2012 14:15:03 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Ive got a requirement for disabling / enabling IP based on the following 
criteria

- Only allow pre authenticated traffic [hostapd/wired 802.1x for example]
- Limit this to a predetermined session limit by duration or throughput
- Disable traffic once idle for a predetermined duration
- Ability to read the information / reset sessions from user space

the application in mind is to deliver small micro servers running our 
linux distro
for remote office / SOHO VPN connectivity with out the need for mid to 
high end
switches control and monitor the usage on the VPN and or other points after
authenticating to the Remote site.

i have a embryonic framework of this that is coming together nicely and 
consists of the following

a table structure consisting of 2 list head pointers [arrays] one for 
mac one for ipaddr the
list data is linked to each based on jhash of mac address [only 
information available from userland pre dhcp]
and the IP[4/6] addr set latter by the target [ideally based on DHCP  i 
may add a DHCP protocol
based match target] this allows for quick lookups and access based on 
IP/MAC pair.

the block of memory used for this is  (2 + 2 * num_buckets)  *  
sizeof(struct list_head).
struct list_head consists of 2 pointers [next/prev].

this is similar to the method borrowed from the xt_recent match.

the userland interface is done via a char dev with sysfs/udev support

- /proc/net/ interface using seq operations for listing all sessions

- /dev/ char dev for reading / writing session information memory is 
allocated
   for each access and a buffer used for reading / writing userland will 
write a
   action [add/delete/view/....] the output will be placed in a buffer 
to be read

- netfilter target and iptables extension that will restrict traffic
   im currently busy with this. it at the moment passes traffic has no check
   and allows 2 flags --use-dest [should not be needed] --save-ip [to 
assosiate the
   ip with MAC this should ideally be done based on the IP assigned via 
DHCP] this
   will only be done if there is no IP set. as the MAC is only available 
on INPUT traffic
   we need to have the IP for accounting of traffic from dest.

using the incoming packet look up the session by mac addr and store the 
source IP
to match returning traffic latter if there is no session traffic is 
DROPED if the ip
is set and the IP/MAC is mismatched drop the packet

iptables -A [INPUT/FORWARD/PREROUTING] -j SESSION --save-ip

once the IP has been set returning packets will be allowed as the IP 
will be
looked up and if assosiated to a valid session it will be allowed to 
continue

iptables -A [ANY] -j SESSION [--use-dest]

for every packet that is allowd the len / time will be updated in the 
session.

a session is only valid when a MAC[if avail]/IP match or the session 
timer has not
expired or the last packet seen and current packet do not differ by more 
than optional
idle time.

the current code is available here
http://pbx.distrotech.co.za/svn/netfilter_session/

please note work is been done on the actual target and what is written 
here is a proposal
the current target passes all traffic.

once the module is loaded the following works
echo "[6 char]" > /dev/8021x
cat /proc/net/8021x

ie
echo "abcdef" > /dev/8021x
cat /proc/net/8021x
61:62:63:64:65:66       1333973169

this creates the session for MAC 61:62:63:64:65:66 @ timestamp there is 
no session limit or time out so all traffic will pass once the ip
is registered.

Hope this is found to be potentially useful something that is suitable 
for inclusion once complete.

all comments are welcomed

Regards Greg

--
This message has been scanned for viruses and
dangerous content by Distrotech Solutions, 
it is believed to be clean.

http://www.distrotech.co.za

