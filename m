From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] ipt_ULOG delays packets caught by filter
Date: Tue, 20 Jul 2004 03:37:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40FC774C.9010300@eurodev.net>
References: <20040720001021.GA4226@wonderland> <40FC6B44.50407@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ruby.joker@op.pl,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Patrick McHardy <kaber@trash.net>
In-Reply-To: <40FC6B44.50407@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira wrote:

> Hi,
>
> ruby joker wrote:
>
>> Maybe bug is hard to notice but it decrease ulog reliability.
>> [1] 
>> http://lists.netfilter.org/pipermail/netfilter-devel/2004-June/015860.html 
>>
>>  
>>
>
> I think that this behaviour is related to the default qthreshold 
> value. If I'm not wrong, we could fix this problem setting the default 
> value to 0 instead of 1. In that case we need to update the iptables 
> man page. If I'm missing something, please let me know.


please forget this comment, I was under a wrong impression.

regards,
Pablo
