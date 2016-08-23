From: Brian Haley <brian.haley@hpe.com>
Subject: Re: [PATCH iptables] iptables-restore: add missing arguments to usage
 message
Date: Tue, 23 Aug 2016 09:55:18 -0400
Message-ID: <d2826f00-ba96-5594-e529-0161d6926006@hpe.com>
References: <7d2cbd95-2442-a2c2-4faa-e2da7f2f0507@hpe.com>
 <20160823121031.GA27842@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-dm3nam03on0110.outbound.protection.outlook.com ([104.47.41.110]:59702
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754825AbcHWNzY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Aug 2016 09:55:24 -0400
In-Reply-To: <20160823121031.GA27842@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/23/2016 08:10 AM, Pablo Neira Ayuso wrote:
> On Mon, Aug 22, 2016 at 02:47:15PM -0400, Brian Haley wrote:
>>
>> iptables-restore was missing -n, -T and -M from the
>> usage message, added them to match the man page.
>>
>> Signed-off-by: Brian Haley <brian.haley@hpe.com>
>>
>> diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
>> index 9393924..dc0acb0 100644
>> --- a/iptables/ip6tables-restore.c
>> +++ b/iptables/ip6tables-restore.c
>> @@ -43,13 +43,14 @@ static void print_usage(const char *name, const char *version) __attribute__((no
>>
>>  static void print_usage(const char *name, const char *version)
>>  {
>> -	fprintf(stderr, "Usage: %s [-c] [-v] [-t] [-h]\n"
>> +	fprintf(stderr, "Usage: %s [-c] [-v] [-t] [-h] [-n] [-T table] [-M command]\n"
>
> Could you also propagate these changes to iptables/xtables-restore.c?

Sure, I'll send a v2.
