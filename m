From: "Hime Junior" <hime@engineer.com>
Subject: Re: [PATCH] fuzzy.patch and fuzzy6.patch.ipv6
Date: Sun, 04 May 2003 19:05:39 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030505000539.32918.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
To: laforge@netfilter.org, baggins@sith.mimuw.edu.pl,
  cieciwa@alpha.zarz.agh.edu.pl, netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


 Hi !

 My comments go along the message...

> On Fri, May 02, 2003 at 11:15:05PM +0200, Jan Rekorajski wrote:
 
> > They're because of the floating point usage, you won't see them on ix86
> > because gcc uses native FPU instructions there - 

Yes - the FP operations were in the generated code.

> > silently building incorrect code,

 The generated code must be fixed then - FP instructions are not a problem , they are a solution even for system software . If the machine context is not being saved , let us save it at once , redesigning compilers , CPUs and brains , if necessary .

 After all , soft computing is out there to stay , and doing fuzzy math without FP operations is , sometimes , unfeasible (it is not the case here) .

 Anyway , I agree 100% that kernel code should NOT contain any FP operations , that are (at present) too slow , but a compiler with a good optimizer could have made the proposed change silently , eliminating FP operations from the generated code by means of inline , equivalent integer arithmetic instructions.

> > but on other architectures gcc uses math emulation
> > library thus generating unresolved symbols.
> 

 OK - now we know the reason for the messages ...

> This is what I was assuming. I think I've seen this happen on PPC
> before.

> 
> > The primary reason was to eliminate the usage of FPU from kernel,
> > unresolved symbols is just the effect of this on non-ix86 archs.
> 
> I'll apply the patch now.

 As I said before,the qualitative behavior is virtually the same AND THIS TIME ALL FP OPERATIONS ARE GONE !!!
     (I SAW IT IN THE NEW GENERATED CODE)

       Thanks to all .

-- 
__________________________________________________________
Sign-up for your own FREE Personalized E-mail at Mail.com
http://www.mail.com/?sr=signup
