From: Padam J Singh <padam.singh@inventum.cc>
Subject: Re: Ruleset creation process.
Date: Mon, 04 Oct 2004 11:55:34 +0530
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4160ECDE.20005@inventum.cc>
References: <415E83B5.5090301@inventum.cc>
	<Pine.LNX.4.61.0410031804410.16241@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020903030706040005070409"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0410031804410.16241@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020903030706040005070409
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit



Henrik Nordstrom wrote:

> On Sat, 2 Oct 2004, Padam J Singh wrote:
>
>> Is there are document that specifies the ruleset creation process?
>
>
> What part of the ruleset creation process?
>
>> I recently had an issue with destroy being called for old rules when 
>> adding a new rule for the same target.
>
>
> Destroy of what, where?
>
> If you refer to the match/target destroy functions being called then 
> this is by design of iptables. Each modification to an iptable results 
> in a new table being installed in the kernel and the old deleted.

Yes, I am talking about the target destroy functions.

What  is happening is that once i add a new rule, the old rule's
checktarget is called first then it's destroy, leaving my internal
states invalid.

So maybe I should traverse the rule link list and setup my internal
structures according to that?

>
> Regards
> Henrik
>
>
Regards,
Padam J Singh


--------------020903030706040005070409--
