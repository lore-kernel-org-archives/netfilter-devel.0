From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [RESEND PATCH 2/2] nfacct: adding quota capabilities
Date: Tue, 29 Apr 2014 08:03:51 -0600
Message-ID: <CANLsYkx11G7ZE6E58dgzRbRjJKDiPOGvj5z5kh1p=pLyHCKpZA@mail.gmail.com>
References: <1398041896-8479-1-git-send-email-mathieu.poirier@linaro.org>
	<1398041896-8479-2-git-send-email-mathieu.poirier@linaro.org>
	<20140428085625.GA18836@localhost>
	<20140428102033.GA3842@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20140428102033.GA3842@localhost>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 28 April 2014 04:20, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Apr 28, 2014 at 10:56:25AM +0200, Pablo Neira Ayuso wrote:
>> > @@ -526,28 +569,93 @@ static int nfacct_cmd_help(int argc, char *argv[])
>> >
>> >  static int nfacct_cmd_restore(int argc, char *argv[])
>> >  {
>> > -   uint64_t pkts, bytes;
>> > -   char name[512];
>> > -   char buffer[512];
>> > -   int ret;
>> > +   uint64_t pkts, bytes, quota;
>> > +   char name[512], mode[512], buffer[512];
>> > +   int ret, flags;
>> >
>> >     while (fgets(buffer, sizeof(buffer), stdin)) {
>> >             char *semicolon = strchr(buffer, ';');
>> > +
>> >             if (semicolon == NULL) {
>> >                     nfacct_perror("invalid line");
>> >                     return -1;
>> >             }
>> > +
>> > +           /* a single ';' terminates the input */
>> > +           if (strncmp(buffer, ";", 1) == 0)
>> > +                   break;
>>
>> This chunk seems new, why is it needed there?
>
> I have applied this patch, we can clarify this or remove it in a
> follow up patch.

I found what I think is a problem with the restore command.  I will
setup the environment and get back to you with a printout of the
condition - just give me a few days.
