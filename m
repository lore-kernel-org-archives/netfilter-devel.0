From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: Bachelor Project
Date: Fri, 4 Nov 2005 13:34:20 +0100
Message-ID: <200511041334.20360@nienna>
References: <436B4D2E.8080204@seznam.cz>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jan Simbera <xcidar@seznam.cz>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <436B4D2E.8080204@seznam.cz>
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


  Hi,

On Friday 04 November 2005 12.59, Jan Simbera wrote:
> Has anybody implemented the feature for the netfilter ( the
> nf_conntrack, the generic, not the IPV4 ) module which deals with
> reduplication of the connection status (e.g. when we have two
> redudant routers/firewalls)  or has anybody being working on
> it presently? I need this information because it is one of the topics
> of my new bachelor project. Does
> anybody know about any contacts or addresses, where i could get this
> information?

  I don't think anyone is currently working on this. The most up-to-date 
IPv4 specific code is in the Netfilter SVN 
(branches/netfilter-ha/linux-2.6-multigroup), and it shouldn't be 
_that_ hard to port it to nf_conntrack.

  The difficult work would be getting it to a state where we can safely 
recommend it for production use... (As currently it contains a lot of 
bugs and even a couple of features are missing.)

  Contact addresses: {laforge,hidden} at netfilter.org or the 
netfilter-ha mailing list on lists.netfilter.org.

-- 
 Regards,
  Krisztian Kovacs
