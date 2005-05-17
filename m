From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH pom-ng 4/6] H.323: splitted ip_conntrack_h323.c into 3
 sources
Date: Tue, 17 May 2005 17:39:38 +0200
Message-ID: <428A103A.2040205@trash.net>
References: <20050510225019.GA5102@roonstrasse.net>
	<20050510225255.GD5720@roonstrasse.net>
	<428297FE.1040900@trash.net>
	<20050512052604.GA18421@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, laforge@gnumonks.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20050512052604.GA18421@roonstrasse.net>
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

Max Kellermann wrote:
> On 2005/05/12 01:40, Patrick McHardy <kaber@trash.net> wrote:
> 
>>This file looks a bit unnecessary, I suggest to put register/unregister
>>in ip_conntrack_h323_h225.c.
> 
> I splitted the file because it became very large (I dislike sources >
> 500 lines). I decided to make a _core.c because this way, the _h225.c
> and _h245.c contain only protocol parser code, and nothing else -
> still having the option to add more "common" code to _core.c (whatever
> happens in further development).
> 
> In the compiled binary, there is no advantage of merging _core and
> _h225.c.
> 
> A matter of personal taste. If you vote me down on this one, I'll
> change it.

Well, lets keep it this way for now and wait if something else is added.
If we decide to merge it some day we can still change it.

Regards
Patrick
