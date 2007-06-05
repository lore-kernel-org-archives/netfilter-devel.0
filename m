From: Dmitry Mishin <dim@openvz.org>
Subject: Re: iptables throws unknown error - suspecting 32/64 compat issue
Date: Tue, 5 Jun 2007 17:50:02 +0400
Message-ID: <200706051750.03185.dim@openvz.org>
References: <Pine.LNX.4.61.0705100812440.32349@yvahk01.tjqt.qr>
	<4665542F.9020607@trash.net> <466565F6.7070902@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: sparclinux@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <466565F6.7070902@trash.net>
Content-Disposition: inline
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

On Tuesday 05 June 2007 17:32, Patrick McHardy wrote:
> Patrick McHardy wrote:
> > Dmitry Mishin wrote:
> >>It's better, but I see the issue with iterate with compat_check_entry()
> >> calls. If it fails, some of target/matches' check_* functions are
> >> called, some not. Please, review my version of this patch.
> >
> > You're right again, thanks. Patch applied.
>
> With one minor change:
No probs, thanks Patrick, for your work!

-- 
Thanks,
Dmitry.
