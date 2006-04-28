From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: condition for 2.6.16
Date: Fri, 28 Apr 2006 12:46:39 +0200
Message-ID: <200604281246.40488.max@nucleus.it>
References: <200604201919.19246.max@nucleus.it>
	<200604231547.29009.simonl@parknet.dk> <4451C06D.8000108@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4451C06D.8000108@trash.net>
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

On Friday 28 April 2006 9:12 am, Patrick McHardy wrote:

> I'm not really buying that argument, this can all also be done in
> userspace. But a lot of people seem to consider it useful, so I might
> reconsider if someone cleans it up so it at least doesn't need to walk
> the list of conditions for every packet it matches .. but no promises.

I'll set to work on it. I'll need to change the userspace interface, though.
The only O(1) way to do it is to store a pointer (or any other id) in the rule 
itself. I didn't do it in the previous version because I though this was 
really ugly. I can't find any other match doing a similar thing. Anyway I can 
do it.

On the other hand I can make it a guaranteed O(log n) or average O(1) without 
meddling the rule descriptor and with compatible userspace. What do you 
prefer?

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
