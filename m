From: Juha Heljoranta <juha.heljoranta@evitech.fi>
Subject: Re: iptables target conflict?  ROUTE and MASQUERADE [off-topic]
Date: 16 Dec 2003 16:23:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1071584637.1714.52.camel@jazz>
References: <BAY13-F105p0oKHV3SF000296b7@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <BAY13-F105p0oKHV3SF000296b7@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2003-12-16 at 10:55, Wu Nick wrote:
> However, 
> I've 
> got several pppoe connections at the same time to connect the Internet.  I 
> dial 
> up several pppoe connections at the same time, and I'm using ROUTE to 
> redirect 
> packets to different ppp interfaces.  But this will defeat the design of 
> MASQUERADE. That is, I'd like to send packets out from different ppp 
> interfaces 
> and their source IP addresses needed to be changed to the IP addess of the 
> specific ppp interface.  Do you have any idea about how to do?

Don't know what you are up to but it sounds like "load balancing" to me.
I have three pppoe connections "balancing" traffic from intranet to
internet.

I have to use two computers to do the trick:
   intranet --> computer 1 --> computer 2 --> internet

I have several computers in my intranet (x.x.0.0). Computer 1 does
   -t nat -A POSTROUTING -o ethx  -s x.x.0.0 \
     -j SNAT --to-source  x.x.1.20-x.x.1.22
That is, gives random ip for outgoing connection (this is the
"balancing"). Computer 2 does
   -t nat -A POSTROUTING -o ppp0 -s x.x.1.20 -j  MASQUERADE
   -t nat -A POSTROUTING -o ppp1 -s x.x.1.21 -j  MASQUERADE
   -t nat -A POSTROUTING -o ppp2 -s x.x.1.22 -j  MASQUERADE
and
   ip rule add from x.x.1.20 table pppoe0
   ip rule add from x.x.1.21 table pppoe1
   ip rule add from x.x.1.22 table pppoe2

Problems with the solution: 1/3 rd of the passive ftp connection
attempts fail. Masquerade will broke if ip changes for any ppp (this
might be distribution specific problem).

There are probably far more elegant solutions. Using singe computer to
do the job wasn't possible at the time I build it. Nowadays, dunno.

Regards,
Juha Heljoranta
juha.heljoranta-AT-evitech.fi
