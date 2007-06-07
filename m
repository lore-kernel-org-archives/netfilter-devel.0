From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH 0/3] Misc cleanups
Date: Thu, 7 Jun 2007 08:56:36 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706070856250.1547@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706042108010.20829@yvahk01.tjqt.qr>
	<4666DCA6.8020400@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4666DCA6.8020400@trash.net>
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


On Jun 6 2007 18:11, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> along comes...
>> another bunch of patches. Cleanups this time.
>>  [1/3] netfilter-have-some-const-tags.diff
>>  [2/3] netfilter-remove-inline.diff
>>  [3/3] netfilter-remove-redundant-braces.diff
>
>Thanks Jan. I'll let them sit on netfilter-devel for a few more
>days and will apply them on Sunday or Monday.
>
>BTW, if you would like to do more cleanups, getting rid of the
>ugly DEBUGP macros and using pr_debug instead would be nice :)
>But please don't just do global search and replace, I would like
>to preserve alignment of multiline statements and 80 character
>line length.

Right, I'll see to that today.


	Jan
-- 
