From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: conntrack and IKE confused on 2.6.16
Date: Wed, 22 Mar 2006 18:31:17 +0100
Message-ID: <BAY103-F14003302261358DE14249BB2D90@phx.gbl>
References: <44218850.5080602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <44218850.5080602@trash.net>
To: kaber@trash.net
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

Patrick McHardy wrote:

>Marco Berizzi wrote:
> > Hi. I'm experimenting a quite strange problem
> > with linux 2.6.16
> > Yesterday one of our user with his laptop has
> > killed my ipsec vpn ;-)
> > Here is my network schema:
> >
> > 
>priv-net-fi--|lnx|--pub-ip-fi**internet**pub-ip-ve--|lnx2.6.16|--priv-net-venezia
> >
> >
> > The is an ipsec tunnel between the two private
> > networks: priv-net-fi and priv-net-venezia. The
> > two ipsec endpoint addresses are pub-ip-fi and
> > pub-ip-ve. So far so good.
> > On the 2.6.16 box there is a forward & nat rule
> > that allow also udp 500: packet with dport=500
> > from the priv-net-venezia are allowed to be
> > forwarded & natted (with pub-ip-ve) to the
> > internet. Our user has double clicked on the vpn
> > connection and his laptop has tried to establish
> > an ipsec tunnel with the system lnx (for the
> > priv-net-fi subnet): packet with dport=500 was
> > natted (with the pub-ip-ve) and forwarded to
> > pub-ip-fi.
> > Ok, time for IKE rekey: lnx (pub-ip-fi) try to
> > talk to lnx2.6.16 pub-ip-ve, but lnx2.6.16 forward
> > packets with dport=500 to the user laptop (172.16.1.227):
> >
> > This is 'cat proc/net/ip_conntrack | grep 172.16.1.227':
> >
> > udp      17 169 src=172.16.1.227 dst=pub-ip-fi sport=500 dport=500
> > packets=51 bytes=9264 src=pub-ip-fi dst=pub-ip-ve sport=500 dport=500
> > packets=77 bytes=29760 [ASSURED] mark=0 use=1
>
>I'm not sure I understand you correctly. The notebook users
>establishes a VPN to the remote side.

Yes.

>Why shouldn't the
>IKE-traffic be directed back to him?

lnx and lnx2.6.16 must talk each other to
establish/renew the ike/ipsec sa, but lnx2.6.16
is directing packets for itself to the notebook.
Is this clear?
