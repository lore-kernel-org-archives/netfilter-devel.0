From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: [RFC]: extend iptables' AUDIT target functionality
Date: Sun, 17 Feb 2013 19:18:09 +0000
Message-ID: <51212CF1.8060500@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Thomas Graf <tgraf@infradead.org>,
	Eric Paris <eparis@redhat.com>, Steve Grubb <sgrubb@redhat.com>
To: Linux-audit <linux-audit@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:64218 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab3BQTSS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Feb 2013 14:18:18 -0500
Received: by mail-wg0-f48.google.com with SMTP id 16so3976815wgi.15
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Feb 2013 11:18:16 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As it stands currently, when a NETFILTER_PKT type message is logged by 
the audit daemon for ICMP type 3 messages (destination unreachable), I 
get absolutely no information in that log as to who/what caused that to 
be triggered by the kernel, apart from, may be, the SELinux context. I 
get something like:

type=NETFILTER_PKT msg=audit(16/02/2013 07:10:28.004:7802) : action=0 
hook=3 len=80 inif=? outif=eth4 saddr=10.2.7.2 daddr=10.3.0.6 ipid=21794 
proto=icmp icmptype=destination-unreachable icmpcode=1 
obj=system_u:object_r:web_client_pkt_t:s0

I have managed to successfully change the AUDIT iptables target to 
include additional information from the original connection which caused 
this ICMP type message to be emitted, though before committing and 
issuing the relevant patches, I thought to seek more broad consensus as 
to what I should include as additional information in that audit log.

When ICMP type 3 message is triggered (that is also valid for type 4 - 
"source quench", and type 11 - "time exceeded" ICMP messages), and also 
depending on the type of the original connection, the following 
information is available to the modified AUDIT iptables target and could 
be transferred in the audit log for that (original) connection:

IP-related properties:
~~~~~~~
1. Source IP address;
2. Destination IP address;
3. Protocol used;
4. Type of service (TOS) value of the original packet;
5. Time-to-live (TTL) value of the original packet;
6. Checksum;
7. Total length of the original packet;

TCP-related (valid only when the original connection was TCP):
~~~~~~~~~
1. Source port;
2. Destination port;
3. TCP flags of the original packet;
4. TCP sequence value of the original packet;
5. Acknowledgement sequence number of the original packet;
6. Checksum;
7. Window size value;

UDP-related (valid only when the original connection was UDP):
~~~~~~~~~
1. Source port;
2. Destination port;
3. Packet length (header + payload) of the original packet;
4. Checksum;

SCTP-related (valid only when the original connection was SCTP):
~~~~~~~~~~
1. Source port;
2. Destination port;
3. Checksum;

Please note that this is *all* the data available to the AUDIT target, 
not what is (or should be) included in the audit logs!

As it stands, I have currently included the following in the AUDIT 
target to be logged, though this is not final, as I am still seeking 
more broad consensus, hence this email:

IP-related properties: Source & destination IP addresses, protocol and 
total length of the original packet;
TCP-related: Source & destination ports, TCP flags;
UDP-related: Source & destination ports;
SCTP-related: Source & destination ports;

As already mentioned, there are at least two things I am still 
considering: 1) should I add/exclude some of what I just listed above?; 
and 2) what should be the structure of the audit message?

For the latter, I have currently placed everything in a single audit 
message: the properties of the ICMP audit message (as shown in the 
example above), plus the field name/value pairs of the original 
connection added after that. They are currently named as "oX=V", where 
"X" is the brief description of the property in question and "V" is its 
value (in other words, TCP source port with a value of 443 of the 
original connection is constructed as "osport=443" in the final audit 
message).

I would like to know whether there are any objections, new ideas or 
suggestions to the above before committing this and issuing the relevant 
patches. Thanks!
