From: Simon Lodal <simonl@parknet.dk>
Subject: Re: [RFC][0/2] New netfilter match module
Date: Wed, 31 May 2006 06:39:19 +0200
Message-ID: <200605310639.19724.simonl@parknet.dk>
References: <20060531042351.61834.qmail@web50211.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alex Davis <alex14641@yahoo.com>
In-Reply-To: <20060531042351.61834.qmail@web50211.mail.yahoo.com>
Content-Disposition: inline
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


> > The reverse match ("interface of ip") could also be interesting to detect
> > martian traffic very easily.
>
> What is "martian traffic"?

Traffic coming in on a wrong interface, ie. another interface than the host 
would route a reply to.


Simon
