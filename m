From: Jesse Peng <jesse@deansoft.com.tw>
Subject: Re: Counter problem in a new nat target.
Date: Thu, 11 Dec 2003 11:20:15 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD7E26F.2020209@deansoft.com.tw>
References: <Pine.LNX.4.44.0312101514250.10808-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Emmanuel Guiton <emmanuel@netlab.hut.fi>,
   netfilter-devel@lists.netfilter.org, KOVACS Krisztian
 <hidden@balabit.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:

>Making other designs relating conntrack entries with custom data either 
>requires abusing one of the existing fields and risk catastrophic results 
>if there ever is a conflict with the originally intended use of these 
>fields or by building an index outside of the conntrack table which is 
>both complex and error prone.
>
>  
>
The conntrack->help.Private_connection_helper_info and 
conntrack->nat.help.Private_nat_helper supposed not that much accused 
been abused.They exist only if you need a helper put his private data, 
so once not overlapsed with other helpers(You know the traffic your 
helper wants is not what any other helper wants) is for sure, than You 
of cource can put your helper data there. I think a helper exist not 
stonely if a registered helper exist or even a conntrack->helper exist, 
that depends on how you judge the "existence", by soul or by body ;)!
