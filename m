From: James Morris <jmorris@intercode.com.au>
Subject: Re: [libipq] parallel userspace program
Date: Fri, 25 Oct 2002 00:46:54 +1000 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Mutt.LNX.4.44.0210250044330.14808-100000@blackbird.intercode.com.au>
References: <39672.131.227.89.21.1034949772.squirrel@www.ecm.surrey.ac.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wei koong Chai <W.Chai@eim.surrey.ac.uk>
In-Reply-To: <39672.131.227.89.21.1034949772.squirrel@www.ecm.surrey.ac.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 18 Oct 2002, Wei koong Chai wrote:

> Hi...
> 
>    I am wondering whether the userspace (QUEUE target) in the netfilter
> architecture can support parallel libipq program. I mean, if i develop
> a userspace program using libipq that takes some parameters, can i run
> the program more than one time simultaneously with different
> parameters?
> 

Not with the current code.

Harald Welte did some work on a queue multiplexor, which may be of some 
interest, see 
http://www.gnumonks.org/projects/project_details?p_id=2


- James
-- 
James Morris
<jmorris@intercode.com.au>
