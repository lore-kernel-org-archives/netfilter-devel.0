From: "Samuel Jean" <sj-netfilter@cookinglinux.org>
Subject: Re: Re[2]: Multiple Targets
Date: Sat, 19 Feb 2005 12:31:03 -0500 (EST)
Message-ID: <63258.207.134.0.13.1108834263.squirrel@207.134.0.13>
References: <7174b1e405021900052b4545c4@mail.gmail.com>
	<20050219082851.GA18228@oknodo.bof.de>
	<1589344960.20050219102331@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
In-Reply-To: <1589344960.20050219102331@dns.toxicfilms.tv>
To: "Maciej Soltysiak" <solt@dns.toxicfilms.tv>
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

On Sat, February 19, 2005 4:23 am, Maciej Soltysiak said:

Hi Maciej

> We write these 3 rules:
> iptables -A INPUT -p tcp --dport 53 -j LOG --log-prefix "foo: "
> iptables -A INPUT -p tcp --dport 53 -j MARK --set-mark 1
> iptables -A INPUT -p tcp --dport 53 -j ACCEPT
>
> iptables reads these 3 rules but creates one complex rule for that in
> kernel-space that would read:
> match tcp dport 53 packets on INPUT and do
> 1) LOG --log-prefix "foo: "
> 2) MARK --set-mark 1
> 3) ACCEPT

Consider what will happen if someone tries to -D such rules..

>
> --
> Best regards,
> Maciej
>

Best regards,

Samuel
