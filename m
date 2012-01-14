From: marty <martinbarrowcliff@gmail.com>
Subject: Re: ulogd2 suggest
Date: Fri, 13 Jan 2012 22:27:10 -0500
Message-ID: <4F10F60E.5040102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:60581 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab2AND1N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jan 2012 22:27:13 -0500
Received: by qadc16 with SMTP id c16so327243qad.19
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jan 2012 19:27:12 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Hi Marty,
>
>> 1. when ulogd logs to mysql, and a failure occurs, the last
>> auto_increment value may still contain a previous, used value.
>> So mysql will hang terminally. Transactions should prevent this.
 >
 > You wrote about it earlier, but I still don't understand. As far as I 
see,
 > ulogd2 doesn't use any auto_increment value and doesn't expect such a
 > parameter to be returned when inserting entries to the database. So
 > where's this auto_increment value which may store a previous value 
after a
 > failure?
 >
Sorry, if I didn't make that understandable.
First this is NOT a ulogd2 bug, and I didn't intend to infer that.
And I cannot consider it a mysql bug.
I just wanted to describe why mysql is broken by ulogd2.
Atomic transactions are essential which ulogd does not support by design!
Ulogd2 does have last_key/auto_increment values which "might"
be helpful in future; that is not what I was specifically addressing.

I have seen this happen a couple times, and it was very perplexing.
NFLOG was sending packets constantly, but nothing is being logged.
As soon as I remove last entry in table logging resumes.
Why? I cannot confirm this but I will clarify what I believe:

1. suppose we have a uncontrolled system shutdown; lets say reset.
2. the innodb logs contain last insert id logged, and will automatically
restore last logged state. That is very nice in most cases.
3. If an insert was done to a table with an auto_increment column
and the system fails before the log was written to disk, that ID is lost.
4. On restart the system is restored orderly from the logs, but only 
contains the LAST_INSERT_ID that was logged, not the LAST_INSERT_ID that 
actually was used! It cannot INSERT anything into a unique index
that was already used. DEADLOCK occurs terminally.
So I assume the innodb log is buffered but the insert is not.

Using transactions results in a synchronous write only after ALL
the SQL has been executed and if it crashes in the middle of the
log write it will be rolled back to the last completed transaction
  when state is restored.
That's as close to perfect as we can expect.

But as you know, that is not possible with ulogd2 as it is today.

 > As we discussed, this is (partly) a documentation issue. In PostgresSQL
 > there's no real difference between a stored procedure and a stored
 > function. In mySQL the two things are quite different, as you described
 > above. The current doc is unfortunately quite misleading because it talks
 > about stored procedures but internally invokes SELECT, in which case only
 > stored functions are allowed in mySQL.

Correct. And what about DBI and SQlite?
ALL DBMS have unique differences and should be addressed individually.
Instead they all use util/db.c which will not supports mysql 
transactions and perhaps causes issues with other DBMS.

 > Your patch modified the current behaviour: the proper way is to add
 > supporting new table fields which the filled out with the host ordered
 > data.

I tried that however it didn't work because I didn't hack every module
that used the keys. And the more I did, the worse it got.
So I hacked it for my needs alone. At best I got proof of concept ...

Marty B.

