From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Mangle on a Connection, not on a Packet
Date: Thu, 16 Oct 2003 21:09:47 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310161109.h9GB9lm16121@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello all,

  I want to extend the functionality of the XOR module.  I am cool with the 
connection tracking helper concepts, and I am cool with the way XOR
is doing its mangling as a target .. but what I'm not so cool with is how
I register my intent to mangle a "connection" with conntrack, rather than
the currently registerd mangle .. per a packet .. as with the target.

  The deal is that XOR mangles each packet with a seed/string/primer,
starting at the payload with the first octet in the seed.  Depending on
the blocksize paramater the seed is altered, but in a way that makes 
the seed no harder to retrieve.  Simply, if any part of the XOR'd stream
is guaranteed to be known/repeated (such as an SMTP hello, or a POP3
hello, etc), then the pieces of the key can be readily retrieved.  The point
being that XOR always starts in the same place and runs the same way;
creating a WEP-like issue .. a sort of privacy .. a stream that can be 
analysed and restored quickly (depending on the predictability of the
underlying data).

  What I'd like to do, is to have XOR operate on a stream .. taking the 
seed and working through successive, derrivative, seeds as the
stream purpetuates.  This should greatly increase the strength of the
XOR encryption.  However, to do this, we need to get above a packet.

  There's not a lot of information published in the netfilter docs on this
type of work (mangling).  Is there a nice way to perform non-NAT 
packet mangling in conntrack; or is that the purpose of conntrack-nat?


Thanks,


--
Ian Latter
Internet and Networking Security Officer
Macquarie University
