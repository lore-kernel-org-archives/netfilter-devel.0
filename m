From: Amin Azez <azez@ufomechanic.net>
Subject: Re: does ipset conflict with ipsec SuSE kernel patch?
Date: Fri, 07 Jul 2006 14:38:57 +0100
Message-ID: <44AE63F1.1020707@ufomechanic.net>
References: <8812D8156467224C9E9739E513037EF1F3FD47@moe.nextone.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <8812D8156467224C9E9739E513037EF1F3FD47@moe.nextone.local>
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

Hung Lin wrote:
...

> 
> I removed the above patches and tried to build ipset again, it worked.
> 
> Does this mean IPsec conflicts with ipsets?  The comment of SuSE kernel
> patch said the patches are from netfilter team, and the ipsets are also
> from netfilter.org.  Since they are both belong to netfilter team, is
> there any way to resolve the conflict?
> 
> Please let me know if you need more information.  Thanks for your time.
> 
> P.S.  Please CC to hlin@nextone.com because I didn't subscribe to the
> mailing list.

You need to manually compare the contents of those patches that you
removed with your ipset patch and locate the conflict.

You have to see what the patches are trying to achieve and what the real
nature of the conflict is.

Here it appears that a struct is defined twice, so you have to see if
this struct is defined the same way each time; your question is:
 what is it that suse needs?
 what is it that ipset needs?

You will then merge the struct definition into one that combines both needs.

You will probably then diff this new definition against the one that
suse patched to, to produce a new ipset patch which will apply cleanly
against the standard suse-patched kernel.

There is no magic spell here, but it won't be as hard as you might think.

If you just want a quick-fix, then edit the file with the two
definitions to merge them to something sensible and leave it at that.

Sam
