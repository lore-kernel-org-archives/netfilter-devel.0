From: Amin Azez <azez@ufomechanic.net>
Subject: Re: more nf_conntrack/ip_conntrack questions
Date: Mon, 12 Sep 2005 13:04:40 +0100
Message-ID: <43256ED8.2090500@ufomechanic.net>
References: <43255737.3040109@ufomechanic.net>	<43255BAB.9040508@trash.net>	<200509121129.j8CBT83a022872@toshiba.co.jp>
	<200509121141.j8CBfHp1003079@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200509121141.j8CBfHp1003079@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:

>Sorry,
>
>From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
>Date: Mon, 12 Sep 2005 20:29:07 +0900 (JST)
>
>  
>
>> then I
>>tried to generalize it like ip_ct_tuple_mask_cmp() like layer 4 protocol
>>part.
>>    
>>
>
>What I want to say is ...
>
>I tried to generalize it like the handling of layer 4 protocol part
>in ip_ct_tuple_mask_cmp().
>
>  
>

Sure, I don't have any fault with the structures, just the way the
sizeof is measured for initial zero-ing.

Sam
