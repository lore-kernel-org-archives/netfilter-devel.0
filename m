From: "Moshe Ashkenazi" <moshea@checkpoint.com>
Subject: RE: libipq packet id
Date: Thu, 26 Sep 2002 17:52:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <003601c26574$ae660b10$97025a3e@SHAGWELL>
References: <Mutt.LNX.4.44.0209270037340.12159-100000@blackbird.intercode.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'James Morris'" <jmorris@intercode.com.au>
In-Reply-To: <Mutt.LNX.4.44.0209270037340.12159-100000@blackbird.intercode.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

So how can I modify the packet base on the rule which queue it to
userspace.
W/o knowing the rule number?


Moshe Ashkenazi, 
Technology Integration & Performance, QA
Check Point Software Technologies LTD.
TEL +972-3-7534865   FAX +972-3-7534893

-----Original Message-----
From: James Morris [mailto:jmorris@intercode.com.au] 
Sent: Thursday, September 26, 2002 4:38 PM
To: Moshe Ashkenazi
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: libipq packet id

On Thu, 26 Sep 2002, Moshe Ashkenazi wrote:

> Hi, All -
> 
> I'm using libipq to retrieve packet from netfilter in userspace, and
its
> work cool.
> 
> My question is how can I know on userspace mode from which netfilter
> rule the packet arrive?    
> 

This information is not passed to userspace.

-- 
James Morris
<jmorris@intercode.com.au>
