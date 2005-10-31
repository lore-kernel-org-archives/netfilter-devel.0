From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Unknown Attribute 5/conntrack -L
Date: Mon, 31 Oct 2005 15:41:34 +0100
Message-ID: <43662D1E.4000308@eurodev.net>
References: <Pine.LNX.4.62.0510281303190.11839@bizon.gios.gov.pl>
	<4364E08D.8020402@eurodev.net>
	<Pine.LNX.4.62.0510302240420.22661@bizon.gios.gov.pl>
	<436592AA.6040202@eurodev.net>
	<Pine.LNX.4.62.0510310846320.8000@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.62.0510310846320.8000@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> On Mon, 31 Oct 2005, Pablo Neira wrote:
> <CUT>
> 
>>> PS: Would you find some time to look at 
>>> http://bugzilla.kernel.org/show_bug.cgi?id=5438
>>
>>
>> Can you still trigger that oops with the current working copy from SVN?
> 
> IMHO this is a kernel bug. And to be clear: there is no problem with new 
> version of userspace application/libraries.
> 
> The problem apperas only with _old_ library. There were a lot of API 
> changes and probably kernel does not properly validate user data 
> (boudaries?).

Since the old libnfnetlink_conntrack release, some changes have been 
introduced in kernel space. The corresponding changes to the userspace 
libraries were applied to keep both in sync. To be frank, I'd worry 
about fixing the current bugs, focus on the new libraries and do the 
first 1.0 official release asap.

-- 
Pablo
