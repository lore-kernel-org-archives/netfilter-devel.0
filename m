From: Matteo Croce <rootkit85@yahoo.it>
Subject: Re: UNWANTED state
Date: Thu, 30 Dec 2004 01:39:48 +0100
Message-ID: <200412300139.49266.rootkit85@yahoo.it>
References: <200412300042.18561.rootkit85@yahoo.it>
	<20041229235657.GA11573@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20041229235657.GA11573@linuxace.com>
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

> On Thu, Dec 30, 2004 at 12:42:17AM +0100, Matteo Croce wrote:
> Perhaps you should consider using:
>
> --dport 113 -j REJECT --reject-with tcp-reset
> instead of hacking the kernel to disable icmp rejects?
>

# iptables -I INPUT 1 -p tcp --dport 4567 -j REJECT --reject-with tcp-reset
# hping3 127.0.0.1 -p 4567 -S
HPING 127.0.0.1 (lo 127.0.0.1): S set, 40 headers + 0 data bytes
len=40 ip=127.0.0.1 ttl=255 DF id=0 sport=4567 flags=RA seq=0 win=0 rtt=0


--reject-with tcp-reset sends RST/ACK that are dropped by my firewall

> Why do you care if people get an icmp unreachable when
> the service is down?  You aren't making the box more secure IMO by not
> allowing the icmp error outbound.

Tryng to reduce at minimum unneeded traffic is a sort of protection against 
DOS.
Let's say i have a 4096/400 ADSL.
Someone with a ~512kbit upload can send me an large amount of data on a closed 
port with something like 'hping3 <IP> -S -p <PORT> --flood', and my 400kbit 
upload
will be unable to send 512Kbit of RST/ACKs.
If i drop unwanted data, the attacker needs an upload of ~4200Kbit
to dos my box, since he need to fill my download instead of my upload.

And having such a target will avoid open/close ports as needed, since only 
used ports are available.

-- 
  .""`.     Matteo Croce <rootkit85@yahoo.it>
 : :"  :    proud Debian admin and user
 `. `"`
   `-  Debian - when you have better things to do than fix a system
