From: Elf King <elf@googgun.com>
Subject: Re: iptables-xml userland tool and feedback
Date: Thu, 22 Jan 2004 15:11:48 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40102E84.3090904@googgun.com>
References: <400E4214.1070100@googgun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <400E4214.1070100@googgun.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Harald and all netfilter devers:

Harald, not sure if you got a chance to see my post about an 
iptables-xml utility. If not have a glance at 
http://www.googgun.com/iptables-xml/.

Would there be interest in bundling it into the iptables userland tools?

When you deliberate on whether or not to include a "new feature" like 
this into iptables do remember that while it is a _new_ feature, it 
isn't modifying any code of any existing tools or libraries, nor does 
the tool require any external libraries or components other than those 
required by iptables itself, it is quite standalone and production grade 
and won't interfere with any of the mainline pieces.

Everyone, I am also hoping for some feedback on the proposed XML so i 
can finalize a formal DTD/xsd, as well as create an XSLT template that 
does the reverse a la iptables-restore, so do drop me a note to let me 
know what you think (both positives and negatives because the comparison 
helps).

Cheers,

Ahmed.
