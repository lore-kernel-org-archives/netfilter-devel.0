From: Laszlo Valko <valko@linux.karinthy.hu>
Subject: Re: [OT Re: Question: Variable sized matchinfo
Date: Tue, 21 Jan 2003 17:46:01 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030121174601.A27338@linux.karinthy.hu>
References: <20030120232634.24011.21218.Mailman@kashyyyk> <15916.60267.562015.732567@isis.cs3-inc.com> <3E2D3218.1040805@trash.net> <20030121170702.B24205@linux.karinthy.hu> <3E2D762E.1040001@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Don Cohen <don-netf@isis.cs3-inc.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3E2D762E.1040001@trash.net>; from kaber@trash.net on Tue, Jan 21, 2003 at 05:32:46PM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jan 21, 2003 at 05:32:46PM +0100, Patrick McHardy wrote:
> you're right of course .. one question: i see copy_from_user in many 
> places in the kernel, often within with user supplied
> addresses. Do all of these don't work on sparc64 ? what a horrible 
> architecture ;)
> 
> regards,
> patrick
> 

Look at arch/sparc64/kernel/*.c and you'll see magic in there...
Just to have a small picture of the situation...

And imagine what will happen with x86-64! I doubt that there'll be
a compiler for that platform which produces working 64bit
userspace code real soon. It took about 5 years for sparc... :)))

Laszlo
