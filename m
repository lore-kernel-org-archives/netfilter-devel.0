From: marty <martinbarrowcliff@gmail.com>
Subject: Ulogd deadlocks on server crash.
Date: Sat, 31 Dec 2011 11:34:52 -0500
Message-ID: <4EFF39AC.9000701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51525 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1LaQez (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Dec 2011 11:34:55 -0500
Received: by qadc12 with SMTP id c12so8736680qad.19
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Dec 2011 08:34:54 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a critical situation with NFLOG logging to mysql.
I cannot call this a bug, so lets call it a feature request.
AFAIK this is specific to mysql.
Please let me explain what I have observed...

Lets assume our ulogd stored procedure does inserts and/or updates
to multiple tables with every NFLOG target execution.

Lets assume we are using an auto_increment column for an index number.

Now what happens if the machine crashes in the middle of
an operation?

Correct, we have used the index number, but it was never returned to
ulogd, and possibly not all the tables were populated.
That is a big problem, because from that point on,
NOTHING more will be logged! We are dead in the water.
And worse, no error was logged to tell us what is wrong!!!!

So how can we correct that problem?

We can manually remove all the entries that used that last index.
Baa, that assumes we actually know what is wrong...

Atomic transactions would be a perfect solution and at worst we
would rollback and lose one data entry. But is it guaranteed?
Ha. NOT always. Threads can be evil.
The only guarantee that we cannot get deadlocked would come from ulogd.

If, ulogd initiates an INSERT and does not get a returned index value
it "MIGHT" increment the last insert_id it is holding and try again a
limited number of times until it found a vacant row.
This would at least break the deadlock on the semi-used index id.
At the very least we could keep logging, even if one row was borked.
That would be a much better solution to this problem, IMHO.

Just a idea.
Thank you,

Marty B.

