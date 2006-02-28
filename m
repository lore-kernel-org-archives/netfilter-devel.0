From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [PATCH] Multiple matches of the same type
Date: Tue, 28 Feb 2006 17:28:39 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0602281726240.32525@bizon.gios.gov.pl>
References: <Pine.LNX.4.58.0602270933130.15955@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1306282461-1141144119=:32525"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0602270933130.15955@blackhole.kfki.hu>
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

---187430788-1306282461-1141144119=:32525
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 27 Feb 2006, Jozsef Kadlecsik wrote:

> Hi,
Hi,

> The attached patch adds the ability to specify multiple matches of the
> same type by ip[6]tables. Besides removing a limitation, a few matches
> (recent, u32, set :-) can benefit from the feature.
>
> If two or more matches of the same type are detected then the options are
> assumed to be grouped in order to tell which option belongs to which
> match:
>
> ... -m foo ... <options0> ... -m foo ... <options1> ...

What about -s and -d? I know about ipset but sometimes you need
just two or three addresses.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1306282461-1141144119=:32525--
