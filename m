From: "Frank Bulk" <frnkblk@iname.com>
Subject: conntrack ftp fails to handle PORT (and PASV?) command when split over multiple TCP packets
Date: Sat, 15 Nov 2008 15:13:58 -0600
Message-ID: <!&!AAAAAAAAAAAuAAAAAAAAAKTyXRN5/+lGvU59a+P7CFMBAN6gY+ZG84BMpVQcAbDh1IQAAAATbSgAABAAAACjGmKcXUZtSrl15MejBLj+AQAAAAA=@iname.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0015_01C94734.CF2093E0"
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.mtcnet.net ([199.120.69.26]:45783 "EHLO smtp1.mtcnet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbYKOVcM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Nov 2008 16:32:12 -0500
Received: from FrankBulkLapto (localhost [127.0.0.1])
	by smtp1.mtcnet.net (Spam Firewall) with ESMTP id AB1A411261FD
	for <netfilter-devel@vger.kernel.org>; Sat, 15 Nov 2008 15:14:14 -0600 (CST)
Received: from FrankBulkLapto (DSL10-231.mtcnet.net [208.126.141.231]) by smtp1.mtcnet.net with ESMTP id Wf5n6Me8l9Luon0G for <netfilter-devel@vger.kernel.org>; Sat, 15 Nov 2008 15:14:14 -0600 (CST)
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multipart message in MIME format.

------=_NextPart_000_0015_01C94734.CF2093E0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

I'm working with the tech support of a residential DSL modem vendor on a NAT
issue.  The vendor says they use open source in their products and the logs
show all the typical iptables entries.  

We're using a DSL modem for OOB management of our DSLAMs.  We access the
DSLAM from the internet via the DSL modem's public IP which has been
configured with a DMZ to hit the DSLAM on its private IP.  We can access the
DSLAM via telnet and http, there's no problem there.

The problem occurs when we perform a configuration backup of the DSLAM.  The
DSLAM has a built-in (DSLAM vendor written?) FTP client that uploads the
configuration to our FTP server.  What's unique is that the DSLAM vendor's
FTP client issues each FTP command separately from the closing CRLF
("\r\n").  For example, when the DSLAM logs in it first issues "LOGIN
username" in one packet, and then "\r\n" in the next packet.  Attached to
this post is a trace (I removed the login section to protect the user
credentials) where you can see this happening in packets #1 and #3.
According to the DSLAM vendor it shouldn't matter if the FTP client sends
the command character-by-character in separate packets or in one packet.
That's no problem for non-NATed DSLAMs because the FTP server is supposed to
wait for the closing CRLF, but it appears that iptables doesn't handle the
situation well.

The issue crops up for me when the PORT command is sent.  The PORT (and
PASV) command require an ALG to accomplish the NAT function because the
internal IP in the payload needs to be changed to the public IP.  The ALG
doesn't (and shouldn't) send the PORT command out the WAN interface until
the "\r\n" is received from the FTP client.  The LAN interface facing the
FTP client should be ACKing every TCP packet until the "\n" is received and
then process the PORT command and send out complete command out the WAN
interface.  But it appears iptables doesn't handle this scenario.  An older
post (http://www.kfki.hu/~kadlec/sw/netfilter/ftp_security2.html) suggests
that this is a known issue.

As you can see the attached trace, in packet #7 the PORT command is received
without the CRLF, consistent with this FTP client's behavior.  But iptables
doesn't send an ACK so the FTP client resends the packet (packets #8-15).

Can anyone confirm that iptables still behaves this way, and if so, code a
fix so that no matter how many packets a PORT or PASV command are split over
(in other words, no matter how small the client's MTU) that iptables ACKs
each packet received on the LAN side and the ALG properly reassembles the
command and sends it out the WAN interface?

Regards,

Frank

------=_NextPart_000_0015_01C94734.CF2093E0
Content-Type: application/octet-stream;
	name="ftp-session-2008-11-14-LAN-side-ftp-partial.pcap"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="ftp-session-2008-11-14-LAN-side-ftp-partial.pcap"

1MOyoQIABAAAAAAAAAAAAP//AAABAAAAHO4dSWWwAAA8AAAAPAAAAAAw2nuFfgACXRC1ZggARQAA
Lk5oAABABl41wKgBC8d4RQHDWwAVkWO8joklY+ZQGCcQ9zIAAFRZUEUgSRzuHUnwTgEAPAAAADwA
AAAAAl0QtWYAMNp7hX4IAEUAAChohEAAPQYHH8d4RQHAqAELABXDW4klY+aRY7yUUBAW0MxiAAAA
AAAAAAAc7h1J1k8BADwAAAA8AAAAADDae4V+AAJdELVmCABFAAAqTmkAAEAGXjjAqAELx3hFAcNb
ABWRY7yUiSVj5lAYJxCvDgAADQoAAAAAHO4dSZ/ZAQA8AAAAPAAAAAACXRC1ZgAw2nuFfggARQAA
KGiFQAA9Bgcex3hFAcCoAQsAFcNbiSVj5pFjvJZQEBbQzGAAAAAAAAAAABzuHUlm3gEAVQAAAFUA
AAAAAl0QtWYAMNp7hX4IAEUAAEdohkAAPQYG/sd4RQHAqAELABXDW4klY+aRY7yWUBgW0JZxAAAy
MDAgU3dpdGNoaW5nIHRvIEJpbmFyeSBtb2RlLg0KHO4dSTXfAQA8AAAAPAAAAAAw2nuFfgACXRC1
ZggARQAAKE5qAABABl45wKgBC8d4RQHDWwAVkWO8loklZAVQECbxvCAAAAAAAAAAABzuHUkD4QEA
TgAAAE4AAAAAMNp7hX4AAl0QtWYIAEUAAEBOawAAQAZeIMCoAQvHeEUBw1sAFZFjvJaJJWQFUBgn
EDRLAABQT1JUIDE5MiwxNjgsMSwxMSwxOTUsOTIc7h1Jv4YJAE4AAABOAAAAADDae4V+AAJdELVm
CABFAABATmwAAEAGXh/AqAELx3hFAcNbABWRY7yWiSVkBVAYJxA0SwAAUE9SVCAxOTIsMTY4LDEs
MTEsMTk1LDkyHu4dSXvVCQBOAAAATgAAAAAw2nuFfgACXRC1ZggARQAAQE53AABABl4UwKgBC8d4
RQHDWwAVkWO8loklZAVQGCcQNEsAAFBPUlQgMTkyLDE2OCwxLDExLDE5NSw5MiPuHUmM9QIATgAA
AE4AAAAAMNp7hX4AAl0QtWYIAEUAAEBOkQAAQAZd+sCoAQvHeEUBw1sAFZFjvJaJJWQFUBgnEDRL
AABQT1JUIDE5MiwxNjgsMSwxMSwxOTUsOTIr7h1J4DAEAE4AAABOAAAAADDae4V+AAJdELVmCABF
AABATsEAAEAGXcrAqAELx3hFAcNbABWRY7yWiSVkBVAYJxA0SwAAUE9SVCAxOTIsMTY4LDEsMTEs
MTk1LDkyN+4dSYrODQBOAAAATgAAAAAw2nuFfgACXRC1ZggARQAAQE8JAABABl2CwKgBC8d4RQHD
WwAVkWO8loklZAVQGCcQNEsAAFBPUlQgMTkyLDE2OCwxLDExLDE5NSw5MkruHUmeUQEATgAAAE4A
AAAAMNp7hX4AAl0QtWYIAEUAAEBPcgAAQAZdGcCoAQvHeEUBw1sAFZFjvJaJJWQFUBgnEDRLAABQ
T1JUIDE5MiwxNjgsMSwxMSwxOTUsOTJi7h1JF8gMAE4AAABOAAAAADDae4V+AAJdELVmCABFAABA
UAEAAEAGXIrAqAELx3hFAcNbABWRY7yWiSVkBVAYJxA0SwAAUE9SVCAxOTIsMTY4LDEsMTEsMTk1
LDkyg+4dScNyAgBOAAAATgAAAAAw2nuFfgACXRC1ZggARQAAQFC3AABABlvUwKgBC8d4RQHDWwAV
kWO8loklZAVQGCcQNEsAAFBPUlQgMTkyLDE2OCwxLDExLDE5NSw5MqzuHUkHHQEAPAAAADwAAAAA
MNp7hX4AAl0QtWYIAEUAAChRqAAAQAZa+8CoAQvHeEUBw1sAFZFjvK6JJWQFUBQnELvlAAAAAAAA
AAA=

------=_NextPart_000_0015_01C94734.CF2093E0--

