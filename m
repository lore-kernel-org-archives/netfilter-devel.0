From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [RFC] CONNMARK getsockopt/setsockopt functionality
Date: Mon, 24 May 2004 13:32:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1085398351.1848.30.camel@nienna.balabit>
References: <1085125075.1782.36.camel@nienna.balabit>
	 <Pine.LNX.4.58.0405241212230.27895@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
In-Reply-To: <Pine.LNX.4.58.0405241212230.27895@chris.camcom.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi Chris,

2004-05-24, h keltezéssel 13:17-kor Chris Wilson ezt írta:
> I think I found a small problem with this patch. I'm using 2.4.26 plus 
> latest CVS POM-ng, and after patching with your patch, the kernel doesn't 
> compile.

  Thanks for the fix. Your patch is obviously correct, somehow I
succeeded in messing up the patch :)

  I hope it's otherwise correct.

-- 
 Regards,
   Krisztian KOVACS
