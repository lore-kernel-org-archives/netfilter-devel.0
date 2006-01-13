From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] fix nf_conntrack_netlink expectation dumping/event
	notification
Date: Fri, 13 Jan 2006 10:04:34 +0100
Message-ID: <43C76D22.8050805@trash.net>
References: <43C70536.7000608@netfilter.org>	<43C76BA7.9080204@trash.net>
	<200601130902.k0D92fVM026246@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200601130902.k0D92fVM026246@toshiba.co.jp>
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
>>>Currently we get an oops with nf_conntrack_netlink + nf_conntrack_ftp
>>>because l3num is set to 0xFFFF for the expectation mask. At first sight,
>>>this is correct because l3num is u_int16_t, but the size of the layer-3
>>>array of protocol handlers is AF_MAX (32).
>>>
>>>I could add some checking to verify that l3num is less than 32 in
>>>nf_conntrack_find_l3proto, but such checking is only required for
>>>nf_conntrack_ftp and further application helpers. AFAICS, this is the
>>>cleanest way to fix this problem. Any other suggestion?
>>
>>What is the exact cause for the crash? I looked over the code, but
>>couldn't spot it.

Ah I see now, see the reason is right there in Pablo's mail :)

> I think that root caurse is missing check at __nf_ct_{l3}proto_find().
> I'll write patch for it. It will free people from taking care about
> expectation mask.

I agree, that seems to be the best solution.
