From: Maximilian Wilhelm <max@rfc2324.org>
Subject: Re: [PATCH] libnfnetlink and libnetfilter_conntrack updates
Date: Fri, 29 Dec 2006 04:09:11 +0100
Message-ID: <20061229030911.GA16263@outback.rfc2324.org>
References: <458605B6.8060903@netfilter.org> <45882946.7040108@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <45882946.7040108@netfilter.org>
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

Am Dienstag, den 19 Dezember hub Pablo Neira Ayuso folgendes in die Tasten:

> Pablo Neira Ayuso wrote:
> > The use of the new API is strongly recommended since we plan to remove
> > the obsolete API sooner or later, anyway we'll warn everyone several
> > times before doing so. I'm also planning to port the remaining libraries
> > (libnetfilter_queue/log) to the new API.

> Just for the record, just committed the changes to SVN. I'll prepare a
> new release asap.

What´s the status of this?

I would like to package conntrackd for Debian which will require current
versions of these two libraries if I get it right.

Therefore I´ll need updates of the existing library packages which would
be nice to build from an official release including all your changes
neccessary for conntrackd.

btw: What´s your prophecy about the release date of conntrackd 0.9.2? :)

Ciao & Thanks
Max
-- 
	Follow the white penguin.
