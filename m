From: Martijn Lievaart <m@rtij.nl>
Subject: Re: Port forwarding with iptables
Date: Thu, 02 Sep 2004 09:24:07 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4136CA97.5010901@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "=?ISO-8859-15?Q?KUCKAERTZ_R=E9gis_-_NVISION?=" <regis@nvision.lu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

KUCKAERTZ R=E9gis - NVISION wrote:

>Hello,
>
>Our ISP only allows connections coming from a well-defined list of IP
>addresses. Since we must be able to log on to our servers no matter whe=
re we
>are, I just thought using iptables on one host having one of the author=
ized
>IP addresses would be the solution.
>
>So I went on reading iptables docs and howtos, but as you might guess I
>couldn't stand how to do it exactly. Let's put it correctly stated: eve=
ry
>incoming connection to, say, port 3999 of my host ($HOST_IP) should be
>forwarded to port 123 of the protected server ($SERVER_IP). I tried the
>following two rules:
>
>$IPTABLES -t nat -A PREROUTING -p tcp --dst $HOST_IP --dport 3999 -j DN=
AT
>--to-destination $SERVER_IP:123
>
>   This one should do the forwarding
>  
>

This one looks fine.

>$IPTABLES -t nat -a POSTROUTING -p tcp --dst $SERVER_IP --dport 123 -j
>MASQUERADE
>
>   ... and this one should masquerade
>  
>

That looks non sensical, what are you trying to accomplish? Drop this 
line of thought. MASQUERADE is for when you connect through a 
dynamically assigned IP address, e.g. dial-up.

What you need is a rule in FORWARD to allow the packets to pass. 
Assuming you accept ESTABLISHED (and RELATED) packets somewhere, so the 
replies are handled automagically, you just need to add a rule like

# by now the packet has been updated with a new destination, allow it in=
.

$IPTABLES -A FORWARD -p tcp --dst $SERVER_IP --dport 123 -j ACCEPT

BTW, these kind of questions are better directed to the user list, not t=
he development list.

Cheers,
M4
