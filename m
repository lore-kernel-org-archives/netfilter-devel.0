From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnfnetlink and libnetfilter_conntrack updates
Date: Fri, 29 Dec 2006 22:48:59 +0100
Message-ID: <45958D4B.3090408@netfilter.org>
References: <458605B6.8060903@netfilter.org> <45882946.7040108@netfilter.org>
	<20061229030911.GA16263@outback.rfc2324.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Maximilian Wilhelm <max@rfc2324.org>
In-Reply-To: <20061229030911.GA16263@outback.rfc2324.org>
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

Hi Max,

Maximilian Wilhelm wrote:
> Am Dienstag, den 19 Dezember hub Pablo Neira Ayuso folgendes in die Tasten:
> 
>> Pablo Neira Ayuso wrote:
>>> The use of the new API is strongly recommended since we plan to remove
>>> the obsolete API sooner or later, anyway we'll warn everyone several
>>> times before doing so. I'm also planning to port the remaining libraries
>>> (libnetfilter_queue/log) to the new API.
> 
>> Just for the record, just committed the changes to SVN. I'll prepare a
>> new release asap.
> 
> What´s the status of this?

I have plans to release the new libraries soon, I require from Patrick
for a minor administrative task to do the release but he's currently off.

> I would like to package conntrackd for Debian which will require current
> versions of these two libraries if I get it right.

Not really, I didn't commit the patch for conntrackd to make it use the
new API yet, mainly because I don't want to get people confused.
However, such patch is ready and available in my people netfilter place.
Therefore, I'll do the commit as soon as the libraries are released, of
course this means that we'll be able to drop unnofficial libraries
available in the conntrackd site and use the official ones.

> Therefore I´ll need updates of the existing library packages which would
> be nice to build from an official release including all your changes
> neccessary for conntrackd.
> 
> btw: What´s your prophecy about the release date of conntrackd 0.9.2? :)

It's a recursive question: expect a release after the libraries release ;)

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
