From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: ipt_ACCOUNT accounting target released
Date: Tue, 27 Apr 2004 10:12:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200404271012.29136.thomas.jarosch@intra2net.com>
References: <200404131731.02001.thomas.jarosch@intra2net.com> <200404261336.08119.thomas.jarosch@intra2net.com> <408DB05E.6010706@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <408DB05E.6010706@trash.net>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

> > Did anyone had a chance to take a look?
> > I really would like to see this one in netfilter CVS ;-)
>
> The pom-ng tar has the include and net directory in the
> ACCOUNT directory. You need to place them inside the
> linux directory. Also, the target is very long (>1000 lines)
> and formatted improperly, this makes it hard to review.
> Please stick to Documentation/CodingStyle, especially
> regaring overly long lines (>80 chars) and wasted lines:
>
>      if (table_nr == -1)
>      {
>
> should be:
>
>      if (table_nr == -1) {
>
> C-style comments are prefered over C++-style comments.

Thanks for your reply. I'll fix the coding style
and will post a new patch soon.

> It also looks like some common blocks of code could
> be placed in a seperate function, for example the inner
> blocks in ipt_account_handle_get_data().

Premature optimization is the root of all evil ;-)
Is see what I can do, but IMHO this will increase
the complexity of the ipt_account_handle_get_data() function.

> Why does it need a PAGE_SIZE >= 4096 ?

The internal data layout for a 8 bit network (256 hosts/CLASS C) is
designed to fit into a kernel zero page. As the code is designed for constant
(meaning every second/every 10 seconds) readout of the data,
kmalloc would be too expensive as snapshots of the data are created.

> Please post the patch to the list for easier review.

Ah, ok. I didn't want to spoil the list as it's rather huge
(at least when the userspace library is included),
but I'll post the kernel space part once I've fixed the coding style.

Thomas
