From: Leandro Melo de Sales <leandroal@gmail.com>
Subject: Re: Nat types implemented by IPTABLES - STUN issue
Date: Thu, 6 Jan 2005 03:08:20 -0300
Message-ID: <5bc4c45705010522084d524973@mail.gmail.com>
References: <5bc4c45705010511286ee56a0d@mail.gmail.com>
	<876ef97a05010517193799cae6@mail.gmail.com>
Reply-To: Leandro Melo de Sales <leandroal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <876ef97a05010517193799cae6@mail.gmail.com>
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

Hi....

  So, I can't understand. The STUN RFC says that STUN doesn't support
Symmetric nat. I'm behind a iptables firewall with nat for UDP packets
and I can run some tests successfully. Are you sure that iptables just
cover symmetric nat? If yes, I really need to check that situation.

  Leandro.

On Wed, 5 Jan 2005 20:19:43 -0500, Tobias DiPasquale
<codeslinger@gmail.com> wrote:
> On Wed, 5 Jan 2005 16:28:42 -0300, Leandro Melo de Sales
> <leandroal@gmail.com> wrote:
> >  I'm using an implementation for STUN (RFC 3489:
> > http://www.faqs.org/rfcs/rfc3489.html) written in JAVA
> > (http://stun4j.dev.java.net/).
> >  In this RFC, they describes some nats variations (see STUN RFC
> > chapter 5) some of them supported by STUN specification, like: Full
> > Cone, Restricted Cone, Port Restricted Cone and Symmetric.
> >  So, I have a simple question for iptables developers: what types of
> > nat iptables supports?
> 
> Symmetric only.
> 
> --
> [ Tobias DiPasquale ]
> 0x636f6465736c696e67657240676d61696c2e636f6d
>
