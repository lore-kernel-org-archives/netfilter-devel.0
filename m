From: Joern Nettingsmeier <nettings@folkwang-hochschule.de>
Subject: [Fwd: trivial netfilter compile problem in 2.5.4[34]-mm2]
Date: Tue, 22 Oct 2002 08:45:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DB4F404.B728EEEF@folkwang-hochschule.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
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

hello !

someone on lkml told me to forward my post here:

Joern Nettingsmeier wrote:
> =

> hi *!
> =

> in order to compile 2.5.4[34], i had to add #include
> <linux/netfilter_ipv4> to net/ipv4/raw.c, since it choked on
> NF_IP_LOCAL_OUT being undefined in line 297.
> =

> since i've had this problem for two kernel releases now, i thought i'd
> bring this to your attention.
> =

> regards,
> =

> j=F6rn
> =

> (please cc: me on followups, the archive i'm using to read lkml lags
> badly. thx.)

-- =

J=F6rn Nettingsmeier     =

Kurf=FCrstenstr 49, 45138 Essen, Germany      =

http://spunk.dnsalias.org (my server)
http://www.linuxdj.com/audio/lad/ (Linux Audio Developers)
