From: Scott Andrew Baillie <sbaillie@bigpond.net.au>
Subject: Re: [PATCH] ip_tables.h does not compile when using g++
Date: 16 Sep 2002 18:52:29 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1032202349.1563.20.camel@localhost.localdomain>
References: <1032190296.458.21.camel@localhost.localdomain>
	<20020916140850.GA8967@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020916140850.GA8967@oknodo.bof.de>
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

On Mon, 2002-09-16 at 14:08, Patrick Schaaf wrote:
> > The header file ip_tables.h is included by the kernel and by user
> > space programs so it should compile when using g++.
> 
> I don't understand why you arrive at this conclusion. ip_tables.h is in
> no way a valid documented user level API, and the fact that the existing
> iptables user level code base (all implemented in C) is including it,
> is a design error in the iptables userlevel - good style would be to
> copy those headers into the userlevel distribution, thus properly
> seperating kernel and userlevel headers.

Yes, you are probably right about the good style thing, but the changes
you propose would be a much bigger (and more intrusive) patch than
the small one I submitted.

Currently, the header file iptables-1.2.7a/include/libiptc/libiptc.h
is intended to be used by user space programs. It even has the
construct  :

#ifdef __cplusplus
extern "C" {
#endif

in it which implies that header file was intended to compile using g++.

The header libiptc.h pulls in ip_tables.h from the kernel and this is
where the compile error occurs. I agree with your comment that the 
header files should be restructured into kernel and user-space
sections, and I am prepared to do this, but would the patch be
accepted ? I am not sure. This task sounds like it would have to
be done by one of the netfilter core developers. Am I wrong?

> 
> A future userlevel C++ API to iptables would indeed need to concern
> itself with such things - but there is no such thing in existence
> (and I don't know whether it is under consideration to have a C++
> callable API).
> 

I am currently creating a C++ user level library for iptables using
g++ and the STL. This is how I came across the problem !!!

> I strongly disagree with the "void *" -> "char *" conversion in pure
> kernel headers, because the kernel is by definition geared towards
> gcc with most extensions (and void * arithmetic is one that makes
> sense).
> 

Yes, it seems as though a lot of kernel developers feel this way,
OH well. Actually, I just want my compile problem fixed and I am
prepared to help do the work, what ever way it is done.

> best regards
>   Patrick
> 


Regards,

Scott.
