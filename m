From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Tue, 18 May 2004 11:57:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A9DDF2.3000107@eurodev.net>
References: <Pine.LNX.4.33.0405171427460.29543-100000@blackhole.kfki.hu> <40A93199.3010007@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <40A93199.3010007@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
>
>> On Mon, 17 May 2004, Pablo Neira wrote:
>>
>>> a) Use flags defined in tcp.h instead of bsd flags: I found that these
>>> flags are already defined in linux with different names in tcp.h, so we
>>> could use linux flags instead.
>>
>>
>>
>> Fine, better to use the flags already defined in tcp.h.
>>
>
> I don't think we should use those, they are for use in the tcp control
> buffer, which is also expressed in their name (TCPCB_FLAG_*).


I think that we should, we are "redefining" the size of a wheel :-), and 
also this comment:

------- snipped from tcp.h ------

1130         /* NOTE: These must match up to the flags byte in a
1131          *       real TCP header.
1132          */

--------- end --------

regards,
Pablo
