From: Laszlo Valko <valko@linux.karinthy.hu>
Subject: Re: Question: Variable sized matchinfo
Date: Tue, 21 Jan 2003 17:07:02 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030121170702.B24205@linux.karinthy.hu>
References: <20030120232634.24011.21218.Mailman@kashyyyk> <15916.60267.562015.732567@isis.cs3-inc.com> <3E2D3218.1040805@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Don Cohen <don-netf@isis.cs3-inc.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3E2D3218.1040805@trash.net>; from kaber@trash.net on Tue, Jan 21, 2003 at 12:42:16PM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jan 21, 2003 at 12:42:16PM +0100, Patrick McHardy wrote:
> Oops, i probably missed that.
> Anyway this doesn't seem to be real problem, you could just pass pointers
> and copy_from_user the data. The probleme there is the match is not informed
> if its not needed anymore, so no chance to free the memory.

But consider that the pointer on the kernel-side might not look like
what it looks like on the user-side!

See my patch earlier with a sparc64 compatibility fix. Basically,
you will have to implement a thunk which translates the 32-bit userspace
pointer sent from iptables to a 64-bit kernelspace pointer. The best
solution is to avoid pointers, as the pointer translation usually involves
translating the whole struct being passed because of the field
offset differences.

Laszlo


> 
> Patrick
> 
> 
