From: Patrick Schaaf <bof@bof.de>
Subject: Re: libipq packet id
Date: Thu, 26 Sep 2002 16:54:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020926145450.GA2327@oknodo.bof.de>
References: <Mutt.LNX.4.44.0209270037340.12159-100000@blackbird.intercode.com.au> <003601c26574$ae660b10$97025a3e@SHAGWELL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'James Morris' <jmorris@intercode.com.au>,
  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Moshe Ashkenazi <moshea@checkpoint.com>
Content-Disposition: inline
In-Reply-To: <003601c26574$ae660b10$97025a3e@SHAGWELL>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Sep 26, 2002 at 05:52:13PM +0200, Moshe Ashkenazi wrote:
> So how can I modify the packet base on the rule which queue it to
> userspace.
> W/o knowing the rule number?

Classify the packet again. Why trust the kernel? The sysadmin may be
playing tricks with you, even unintentionally. By reclassifying in
userlevel, you avoid that problem.

Never trust your input.

best regards
  Patrick
