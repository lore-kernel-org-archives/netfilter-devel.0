From: Peteris Krumins <newsgroups@lf.lv>
Subject: Re[2]: performance
Date: Mon, 9 Jun 2003 21:27:30 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <723210746.20030609212730@lf.lv>
References: <3EE4B1EB.9090305@draigBrady.com> <3EE4B2E3.2070700@draigBrady.com>
Reply-To: Peteris Krumins <newsgroups@lf.lv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: P@draigBrady.com
In-Reply-To: <3EE4B2E3.2070700@draigBrady.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Monday, June 9, 2003, 7:16:35 PM, you wrote:

Pdc> P@draigBrady.com wrote:
>> Hi,
>> 
>> I'm testing netfilter performance here on
>> PIII 1.2GHz based systems. With default
>> kernel configuration, netfilter is able
>> to process 85,000 pps with 125 rules (all
>> rules matching).
>> 
>> Note the application is just counting.
>> There is no transmitting/forwarding.
>> 
>> Also note the nics are e100.
>> 
>> So my simple question are there any
>> tips in increasing the performance?
>> Hmm actually the performance seems
>> optimal? is it only taking 9 instructions
>> per match? 1.2*10^9/(85000*1500) = 9

Pdc> I knew that couldn't be right.
Pdc> That was tested on a dual 1.2GHz,
Pdc> so that should be approx:
Pdc> 2*10^9/(85000*125) = 188 instructions per match.

I am afraid that is not instructions per match
but ticks per match? An instruction can take more than
one tick (clock cycle).


P.Krumins
