From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: xt_policy: output policy not valid in PRE_ROUTING and INPUT
Date: Mon, 6 Aug 2007 14:41:13 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708061438011.23493@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0708061317410.23493@bizon.gios.gov.pl>
	<46B7145B.4070407@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-915797213-1186404073=:23493"
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46B7145B.4070407@trash.net>
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

---187430788-915797213-1186404073=:23493
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 6 Aug 2007, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>> Hello,
>>
>> Is there any reason why it is not possible to use "-m policy --dir out"
>> in PREROUTING? I tried to do something like:
>>
>> -A PREROUTING -m policy --dir out --pol ipsec -j RETURN
>> -A PREROUTING -p tcp -i $IF_LANBR --dport 80 -j REDIRECT --to-ports 8088
>
>
> The IPsec policy is selected after routing, which is why can't
> be used in PREROUTING.

Is there any other solution than duplicating ipsec policies with "-A=20
PREROUTING -s (...) -d (...) -p (...) -j RETURN"? I would like to REDIRECT=
=20
only packets that are not going thru ipsec tunnels.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-915797213-1186404073=:23493--
