From: "Julio A. Romero" <julioarr@fisica.uh.cu>
Subject: Fw: ping broadcast into forward chain?? (IN=eth0 OUT=eth0)!!
Date: Mon, 19 Sep 2011 11:34:31 -0400
Message-ID: <A49AF0D2713E4955B1FF9A306DEE3EC6@poweredge1800>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.uh.cu ([200.14.51.4]:44702 "EHLO smtp.uh.cu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab1ISPm2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Sep 2011 11:42:28 -0400
Received: from server.fisica.uh.cu (fisica.uh.cu [10.6.11.1])
	by smtp.uh.cu (Postfix) with ESMTPS id 2CD177C954
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Sep 2011 11:37:03 -0400 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by server.fisica.uh.cu (Postfix) with ESMTP id 7B55F528EB
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Sep 2011 11:36:35 -0400 (CDT)
Received: from server.fisica.uh.cu ([127.0.0.1])
	by localhost (server.fisica.uh.cu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OeU7A7i3+VnD for <netfilter-devel@vger.kernel.org>;
	Mon, 19 Sep 2011 11:36:11 -0400 (CDT)
Received: from poweredge1800 (unknown [10.6.13.2])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: julioarr)
	by server.fisica.uh.cu (Postfix) with ESMTPSA id 50294528E6
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Sep 2011 11:34:55 -0400 (CDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


----- Original Message ----- 
From: "Julio A. Romero" <julioarr@fisica.uh.cu>
To: <netfilter@vger.kernel.org>
Sent: Monday, September 19, 2011 11:29 AM
Subject: ping broadcast into forward chain?? (IN=eth0 OUT=eth0)!!


> This is a real scenario:
>
> My external eth0=10.6.100.109, eth0:0=10.6.100.104
> My internal eth2=10.6.13.254
> My internal networks=10.6.11.0/24,10.6.13.0/24,10.6.40.0/24
>
> Why these packests appear into the forward chain?
>
> My syslog:
>
> ...
> Sep 19 10:44:32 firewall kernel: [316561.880144] FW:FWD:netfilter_fwd:? 
> IN=eth0 OUT=eth0 SRC=10.28.1
> 0.76 DST=10.6.15.246 LEN=60 TOS=0x00 PREC=0x00 TTL=54 ID=17064 PROTO=ICMP 
> TYPE=8 CODE=0 ID=512 SEQ=1
> 2558
> Sep 19 10:44:32 firewall kernel: [316561.880273] FW:FWD:netfilter_fwd:? 
> IN=eth0 OUT=eth0 SRC=10.28.1
> 0.76 DST=10.6.15.247 LEN=60 TOS=0x00 PREC=0x00 TTL=54 ID=17065 PROTO=ICMP 
> TYPE=8 CODE=0 ID=512 SEQ=1
> 2814
> Sep 19 10:44:32 firewall kernel: [316561.881250] FW:FWD:netfilter_fwd:? 
> IN=eth0 OUT=eth0 SRC=10.28.1
> 0.76 DST=10.6.15.248 LEN=60 TOS=0x00 PREC=0x00 TTL=54 ID=17066 PROTO=ICMP 
> TYPE=8 CODE=0 ID=512 SEQ=1
> 3070
> Sep 19 10:44:32 firewall kernel: [316561.882040] FW:FWD:netfilter_fwd:? 
> IN=eth0 OUT=eth0 SRC=10.28.1
> 0.76 DST=10.6.15.249 LEN=60 TOS=0x00 PREC=0x00 TTL=54 ID=17067 PROTO=ICMP 
> TYPE=8 CODE=0 ID=512 SEQ=1
> 3326
> Sep 19 10:44:32 firewall kernel: [316561.882793] FW:FWD:netfilter_fwd:? 
> IN=eth0 OUT=eth0 SRC=10.28.1
> 0.76 DST=10.6.15.250 LEN=60 TOS=0x00 PREC=0x00 TTL=54 ID=17068 PROTO=ICMP 
> TYPE=8 CODE=0 ID=512 SEQ=1
> 3582
> Sep 19 10:44:32 firewall kernel: [316561.883546] FW:FWD:netfilter_fwd:? 
> IN=eth0 OUT=eth0 SRC=10.28.1
> 0.76 DST=10.6.15.251 LEN=60 TOS=0x00 PREC=0x00 TTL=54 ID=17069 PROTO=ICMP 
> TYPE=8 CODE=0 ID=512 SEQ=1
> 3838
> Sep 19 10:44:32 firewall kernel: [316561.884549] FW:FWD:netfilter_fwd:? 
> IN=eth0 OUT=eth0 SRC=10.28.1
> 0.76 DST=10.6.15.252 LEN=60 TOS=0x00 PREC=0x00 TTL=54 ID=17070 PROTO=ICMP 
> TYPE=8 CODE=0 ID=512 SEQ=1
> 4094
> Sep 19 10:44:32 firewall kernel: [316561.885317] FW:FWD:netfilter_fwd:? 
> IN=eth0 OUT=eth0 SRC=10.28.1
> 0.76 DST=10.6.15.253 LEN=60 TOS=0x00 PREC=0x00 TTL=54 ID=17071 PROTO=ICMP 
> TYPE=8 CODE=0 ID=512 SEQ=1
> 4350
> Sep 19 10:44:32 firewall kernel: [316561.886557] FW:FWD:netfilter_fwd:? 
> IN=eth0 OUT=eth0 SRC=10.28.1
> 0.76 DST=10.6.15.254 LEN=60 TOS=0x00 PREC=0x00 TTL=54 ID=17072 PROTO=ICMP 
> TYPE=8 CODE=0 ID=512 SEQ=1
> 4606
> Sep 19 10:44:32 firewall kernel: [316561.889452] FW:FWD:netfilter_fwd:? 
> IN=eth0 OUT=eth0 SRC=10.28.1
> 0.76 DST=10.6.15.255 LEN=60 TOS=0x00 PREC=0x00 TTL=54 ID=17073 PROTO=ICMP 
> TYPE=8 CODE=0 ID=512 SEQ=1
> 4862
> ...
>
> the two involved chains:
>
> ###########################
> # ipv4 - FILTER - FORWARD #
> ###########################
> # FORWARD RULES
> #
> # Forward all traffic to netfilter_fwd
> iptables -A FORWARD -j netfilter_fwd
> # Allow (established|related) connections in returned traffic of 
> netfilter_fwd
> iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
> # Send all other ICMP returned packets to icmpfilter
> iptables -A FORWARD -p icmp -g icmpfilter
> # Send all other UDP returned packets to udpport
> iptables -A FORWARD -p udp -g udpport
> # Send all other TCP returned packets to tcpport
> iptables -A FORWARD -p tcp -g tcpport
> # Send all other returned fragmented packets to average
> iptables -A FORWARD -f -j average
> # Log for debugger
> iptables -A FORWARD -j LOG --log-prefix "FW:FWD:? "
> #######
> # END #
> #######
>
> ###########################
> # ipv4 - FILTER - netfilter_fwd #
> ###########################
> # NETFILTER_FWD RULES
> #
> # Create netfilter_fwd
> iptables -N netfilter_fwd
> # LOG and DROP untrue connections
> iptables -A netfilter_fwd -s $GW_NETWORKS -j LOG --log-prefix 
> "FW:FWD:BOX->* "
> iptables -A netfilter_fwd -s $GW_NETWORKS -j DROP
> iptables -A netfilter_fwd -d $GW_NETWORKS -j LOG --log-prefix 
> "FW:FWD:*->BOX "
> iptables -A netfilter_fwd -d $GW_NETWORKS -j DROP
> iptables -A netfilter_fwd -i $INT_IFACEs -o $EXT_IFACEs -d 
> $INT_NETWORKS -j LOG \
> --log-prefix "FW:FWD:I->E:dst:INT_NET "
> iptables -A netfilter_fwd -i $INT_IFACEs -o $EXT_IFACEs -d 
> $INT_NETWORKS -j DROP
> iptables -A netfilter_fwd -i $EXT_IFACEs -o $INT_IFACEs -s 
> $INT_NETWORKS -j LOG \
> --log-prefix "FW:FWD:E->I:src:INT_NET "
> iptables -A netfilter_fwd -i $EXT_IFACEs -o $INT_IFACEs -s 
> $INT_NETWORKS -j DROP
> # Send outgoing traffic to dstnetfilter for validation of the destination
> iptables -A netfilter_fwd -i $INT_IFACEs -o $EXT_IFACEs -s 
> $INT_NETWORKS -g dstnetfilter
> # Send incoming traffic to srcnetfilter for validation of the source
> iptables -A netfilter_fwd -i $EXT_IFACEs -o $INT_IFACEs -d 
> $INT_NETWORKS -g srcnetfilter
> # LOG and DROP all other traffic
> iptables -A netfilter_fwd -j LOG --log-prefix "FW:FWD:netfilter_fwd:? "
> iptables -A netfilter_fwd -j DROP
> #######
> # END #
> #######
>
> thanks,
> julio 

