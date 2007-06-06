From: "pankaj jain" <jainp1979@gmail.com>
Subject: iptables and martian filtering
Date: Wed, 6 Jun 2007 18:55:27 +0530
Message-ID: <d41814cf0706060625sa4f22efh478c5beb9f6693a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

HI,
I am learning how iptables work, so I was writing rules for PREROUTING
chain in nat table
I was trying to change the destination address in the incoming packet
to 127.x.x.x IP.
since my server is listening on that interface.

I added following rules:
iptables -I PREROUTING -t nat -p tcp -d 192.168.1.10 --dport 23456 -j
DNAT --to-destination 127.0.0.3
iptables -I INPUT -p tcp -d 127.0.0.3 -j ACCEPT
iptables -I INPUT -p tcp -i lo -j ACCEPT
iptables -I OUTPUT -p tcp -s 127.0.0.3 -j ACCEPT
iptables -I OUTPUT -p tcp -o lo -j ACCEPT

server is listening on 127.0.0.3:23456
client is trying to connect to 192.168.1.10:23456

but client is not able to connect to the server
I was getting logs such as "martian destination 127.0.0.3 from
192.168.1.10, dev eth0" in dmesg.

I believe "Martian Address Filtering" is taking place.
is there any way to override this filtering action ?

-- 
Thanks
Pankaj Jain
