From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Cuseeme Patch
Date: 07 Apr 2003 20:31:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049740300.26423.194.camel@tux.rsn.bth.se>
References: <NGBBLGFEALDADHNDAAFFEEFLDJAA.ksmith@perfht.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kevin Smith <ksmith@perfht.com>
In-Reply-To: <NGBBLGFEALDADHNDAAFFEEFLDJAA.ksmith@perfht.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2003-04-07 at 20:18, Kevin Smith wrote:
> I was wondering how well the cuseeme-nat patch works in the field. Just
> looking for pros/cons  and gotchas. 
> Also is there a Minimum kernel version you need to use these patches? mine
> is RH 7.2 2.4.7-10. I have been considering upgrading it since I am probably
> in the Linux dark ages kernelwise. Since I never did one Im also looking for
> some good newbie documentation on that.

I have no idea about the cuseeme-nat patch, you should ask that question
on the users list, netfilter@lists.netfilter.org

About the minimum kernelversion you need to use patch-o-matic, the
answer is that kernel 2.4.18 is the minimum kernel that's supported (but
not tested very frequently so it might not work).

We always recommend the latest stable kernel, currently 2.4.20, with at
least all patches from the pending suite in patch-o-matic applied.
(./runme --batch pending)

-- 
/Martin
