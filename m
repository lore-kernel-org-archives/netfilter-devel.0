From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: [PATCH] RPC match and conntrack modules v2.1
Date: Fri, 10 Jan 2003 19:26:57 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301100926.h0A9QwA05558@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: marcelo.lima@dcc.unicamp.br
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello all,

  I too had too much Xmas idle time and for some reason I couldn't get
enough coding done ... too long between programming sessions, me 
thinks.

  I have uploaded, to the ftp.netfilter.org site, a copy of the new patch-
o-matic ready code.  Let me know what you think of it ... I don't have a
lot of need for RPC traffic filtering, but when I realised that the Linux
kernel filtering for RPCs was limited to the old "record-rpc" modules, I
had to upgrade them ... I wanted some of that CheckPoint functionality
in my favourite filtering API  :oP

  The new modules will allow filtering on RPC procedures (by name or
number).  The intended usage of these modules would be with a ruleset 
like;

    # New session from client to server (rpc portmapper get)
    -A PREROUTING -t nat -i eth0 -p udp -m rpc --rpcs 100002
           -s ${client} --sport 0:1023 -d ${server} --dport 111
           -j ACCEPT

    # Continued session from client to client (port mapper answer)
    -A PREROUTING -t nat -i eth1 -m state -p udp
           -s ${server} --sport 111 -d ${client} --dport 0:1023
           --state ESTABLISHED -j ACCEPT

    # New session from client to server (procedure call)
    -A PREROUTING -t nat -i eth0 -m state -p udp
          -s ${client} --sport 0:65535
          -d ${server} --dport 32000:34000
          --state ESTABLISHED,RELATED -j ACCEPT

    # Continued session from client to server (procedure response)
    -A PREROUTING -t nat -i eth1 -m state -p udp
           -s ${server} --sport 32000:34000
           -d ${client} --dport 0:65535
           --state ESTABLISHED -j ACCEPT


  Which would allow rusers to execute from client to server;

     user@client# rusers $server


Note that if that first rule was without the --rpcs option;
    -A PREROUTING -t nat -i eth0 -p udp -m rpc
           -s ${client} --sport 0:1023 -d ${server} --dport 111
           -j ACCEPT

... then it would behave like the existing oldnat module; simply
"recording" RPC get commands via the portmapper, and letting
them through from the same host when they're a complete
procedure call.


Also note that I've updated the module for newnat, and it compiles
cleanly against 2.4.20.  I was half tempted to author the NAT module
to go with the conntrack and match, but this code has taken too 
much time already.


0f759135c2b2aae5bc39b3ed0f633749  pom-rpc-030110-01.tgz
11371 bytes size

  Comments welcome and appreciated.


Regards,


--
Ian Latter
Internet and Networking Security Officer
Macquarie University
