From: "Jianqing Zhang" <arrow.jianqing@gmail.com>
Subject: Add a rule to PREROUTING table
Date: Mon, 22 Dec 2008 15:44:35 -0600
Message-ID: <8a38e1330812221344l51472479s2ff1e57b4bee08b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

I add a rule to the chain of PREROUTING for the nat table as follows:

 iptables -t nat -I PREROUTING -p udp --dport 4309 -j NFQUEUE --queue-num 0

However, when I run "iptables -L ", I can see nothing under PREROUTING chain

...
Chain PREROUTING (0 references)
target     prot opt source               destination
...

Do miss something?

Thanks
