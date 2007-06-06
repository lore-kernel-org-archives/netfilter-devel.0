From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/3] Misc cleanups
Date: Wed, 06 Jun 2007 18:11:18 +0200
Message-ID: <4666DCA6.8020400@trash.net>
References: <Pine.LNX.4.61.0706042108010.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706042108010.20829@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> along comes...
> another bunch of patches. Cleanups this time.
>  [1/3] netfilter-have-some-const-tags.diff
>  [2/3] netfilter-remove-inline.diff
>  [3/3] netfilter-remove-redundant-braces.diff


Thanks Jan. I'll let them sit on netfilter-devel for a few more
days and will apply them on Sunday or Monday.

BTW, if you would like to do more cleanups, getting rid of the
ugly DEBUGP macros and using pr_debug instead would be nice :)
But please don't just do global search and replace, I would like
to preserve alignment of multiline statements and 80 character
line length.
