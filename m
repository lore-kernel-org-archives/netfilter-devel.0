From: Ozgur Akan <akan@aiqa.com>
Subject: chain_cache
Date: Thu, 13 May 2004 16:30:07 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A3785F.8070803@aiqa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

is "chain_cache->end_off" the adress of last rule of the chain or end of 
the last rule(the place where a new rule will appended (like 
ipt_entry->next_offset))?

struct chain_cache
{
        char name[TABLE_MAXNAMELEN];
        /* This is the first rule in chain. */
        unsigned int start_off;
        /* Last rule in chain */
        unsigned int end_off;
};

thanks,

-- 
Ozgur Akan
