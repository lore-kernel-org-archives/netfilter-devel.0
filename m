From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 4/4] conntrack ftp helper modification to use new
	infrastrure
Date: Mon, 10 Jan 2005 00:31:08 +0100
Message-ID: <41E1BEBC.3030703@eurodev.net>
References: <41E1AEEF.9050005@eurodev.net> <41E1BC3B.5070101@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41E1BC3B.5070101@trash.net>
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

>> #define MAX_PORTS 8
>> static int ports[MAX_PORTS];
>> static int ports_c;
>> @@ -56,30 +56,35 @@
>>     char skip;
>>     char term;
>>     enum ip_ct_ftp_type ftptype;
>> +    struct nf_string_match *sm;
>>  
>>
>
> Why is is part of struct ftpsearch ? One struct nf_string_match per 
> helper
> should be enough as long as we take the global lock.


because the ftp helper looks for four different patterns. The goodshift 
and badshift arrays required by the boyer-moore algorithm are different 
for every pattern.

Actually, I started a version using lists of nf_string_match to look for 
a set of patterns iteratively but I finally decided to simplify the 
thing. If someone finds this feature interesting I could recover it in 
future.

--
Pablo
