From: Patrick McHardy <kaber@trash.net>
Subject: Re: generalized packet modification (inc tcpflags, adding options)
Date: Mon, 30 Jun 2003 19:05:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F006DDC.5010900@trash.net>
References: <16128.27034.85530.861667@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mohammed Awad <MAwad@Enppi.com>,
 Craig Shelley <craig@microtron.org.uk>,
  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-netfil@isis.cs3-inc.com>
In-Reply-To: <16128.27034.85530.861667@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Don,

Don Cohen wrote:

>It's not immediately clear to me what language would be best for 
>describing such modifications and that would probably be worth
>discussing on this list.  For that matter, it's not clear what
>language is best for describing the match.  My u32 language was
>designed to do what seems to be needed for IPv4 but is not good
>for IPv6.  I recall someone (Patrick?) supplied a BPF analog of the
>u32 match.  (Where can I find that, BTW?)  Is that language capable of
>specifying data modification?  Of course other important issues
>include run time efficiency and convenience for the user.
>

I never made that match. It was just an idea which came up while hacking
ppp-filters for isdn, but i let it be because of the fixed-size match 
data problem.
However, BPF is only for specifying filter expressions, not for mangling 
data.

Bye,
Patrick
