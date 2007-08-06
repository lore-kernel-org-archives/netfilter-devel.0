From: Krzysztof Oledzki <ole@ans.pl>
Subject: RE: conntrack clarification
Date: Mon, 6 Aug 2007 12:27:08 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708061209180.23493@bizon.gios.gov.pl>
References: <3434740.221186389567173.JavaMail.root@localhost>
	<24966838.281186390464437.JavaMail.root@localhost>
	<Pine.LNX.4.64.0708061106240.1735@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1577421053-1186396028=:23493"
Cc: 'Eric Leblond' <eric@inl.fr>, netfilter-devel@lists.netfilter.org,
	Andrew Hall <temp02@bluereef.com.au>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708061106240.1735@fbirervta.pbzchgretzou.qr>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1577421053-1186396028=:23493
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 6 Aug 2007, Jan Engelhardt wrote:

>
> On Aug 6 2007 18:54, Andrew Hall wrote:
>>
>>> This is linked with your ruleset. The point to consider is that for the
>>> conntrack NEW is not equivalent to SYN packet for TCP. If you only
>>> filter on NEW, then packet from the previously existing connection will
>>> be classified as NEW and trigger the creation of a new valid entry.
>>
>> This is true, but how? I no longer have a "new" rule to allow connection=
=2E Here's the logic of what I'm trying to do:
>
> Fix your ruleset. From:
>
> -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
>
> to:
>
> -m conntrack --ctstate ESTABLISHED -j ACCEPT
> -m conntrack --ctstate NEW -p tcp --syn -j ACCEPT
> -m conntrack --ctstate NEW -p udp -j ACCEPT
> # (and more for SCTP/DCCP if you need that)

Or:
-p tcp -m conntrack --ctstate NEW ! --syn -j INVALID_NewTCP
-m conntrack --ctstate ESTABLISHED,RELATED -j RETURN

And reset (--reject-with tcp-reset) such connections in INVALID_NewTCP=20
with something like:
iptables -A INVALID_NewTCP -p tcp -m limit --limit 6/s -j REJECT --reject-w=
ith tcp-reset
iptables -A INVALID_NewTCP -j DROP

One may also simply set: sysctl net.netfilter.nf_conntrack_tcp_loose=3D0 (o=
r=20
net.ipv4.netfilter.ip_conntrack_tcp_loose on old kernels) but then it is=20
not possible to reset such connections so simply.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1577421053-1186396028=:23493--
