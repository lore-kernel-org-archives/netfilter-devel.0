From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 1/4] RFC: fast string matching infrastrure for netfilter
Date: Tue, 11 Jan 2005 00:18:13 +0100
Message-ID: <41E30D35.5040405@eurodev.net>
References: <41E1AECD.6020209@eurodev.net>
	<20050110084939.GA11194@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Schuster <schuster.sven@gmx.de>
In-Reply-To: <20050110084939.GA11194@zion.homelinux.com>
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

Sven Schuster wrote:

>>+struct nf_string_match *
>>+nf_string_match_create(const char *pat, int patlen)
>>+{
>>+	struct nf_string_match *sm;
>>+
>>+	sm = kmalloc(sizeof(struct nf_string_match), GFP_KERNEL);
>>+	if (!sm)
>>+		return NULL;
>>+	memset(sm, 0, sizeof(struct nf_string_match));
>>+
>>+	sm->goodshift = (int *) kmalloc(patlen * sizeof(int), GFP_KERNEL);
>>+	if (!sm->goodshift)
>>+		return NULL;
>>+	memset(sm->goodshift, 0, sizeof(int) * patlen);
>>+	
>>+	sm->pat = (char *) kmalloc(patlen * sizeof(int), GFP_KERNEL);
>>+	if (!sm->pat) {
>>+		kfree(sm->goodshift);
>>+		return NULL;
>>+	}
>>+	memset(sm->pat, patlen, sizeof(char) * patlen);
>>    
>>
>
>is there any intention behind kmalloc()ing the pattern using sizeof(int)
>and then memset()ting it using sizeof(char)?
>  
>

yes, I've got a severe brain misfunction or a leak in the copy-and-paste 
facility of my editor :). Thanks, I just fixed those in my tree.

Harald, I'll wait for your news about your patches to reduce the 
pressure in memory allocation. Anyway, I've already got some thoughts 
about libqsearch. I think that it's a bit bloated for kernel space. That 
plugin infrastructure provided by libqsearch is nice but it's much more 
than we need since there are just just two plugins: brute force and 
boyer-moore searchings.

My current implementation doesn't support wildcards[1] but that feature 
isn't difficult to implement, as well as iterative searching of patterns 
loaded in a list.

Wait for your comments.

[1] When talking about wildcards, I mean simple ones, that is, 'p*blo' 
matches 'pablo' but not 'paablo' since boyer-moore shifting can't allow 
that. I know you are aware of that ;).

--
Pablo
