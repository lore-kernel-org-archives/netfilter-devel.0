From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH][IPTABLES] userspace u32 match support
Date: Wed, 15 Nov 2006 10:19:29 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0611151010310.26451@bizon.gios.gov.pl>
References: <4553D66B.2010309@netfilter.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-692183302-1163582369=:26451"
Cc: Harald Welte <laforge@netfilter.org>, Michael Rash <mbr@cipherdyne.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <4553D66B.2010309@netfilter.org>
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

---187430788-692183302-1163582369=:26451
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 10 Nov 2006, Pablo Neira Ayuso wrote:

> Add support for u32 match in userspace

Thanks, but the original u32 match was much more powerful and allowed for=
=20
example to move to a next header (ip->tcp) using the @ operator and=20
generally to build more advanced test. As you used the same name (u32) it=
=20
will be no longer possible to use the old one.

So, are there any plans to implement full power of the old u32 extension?

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-692183302-1163582369=:26451--
